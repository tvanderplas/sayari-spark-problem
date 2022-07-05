
from pyspark.sql import SparkSession
import gzip
import shutil

def gunzip_shutil(source_filepath, dest_filepath, block_size=65536):
    with gzip.open(source_filepath, 'rb') as s_file, \
            open(dest_filepath, 'wb') as d_file:
        shutil.copyfileobj(s_file, d_file, block_size)


spark = SparkSession.builder \
    .master("local[1]") \
    .appName("Sayari Spark Task") \
    .getOrCreate()

spark.sparkContext.setLogLevel("WARN")

# extract files
gunzip_shutil("gbr.jsonl.gz", "gbr.jsonl")
gunzip_shutil("ofac.jsonl.gz", "ofac.jsonl")

# Read JSON into dataframes
gbr = spark.read.json("gbr.jsonl")
ofac = spark.read.json("ofac.jsonl")
gbr.createOrReplaceTempView("gbr")
ofac.createOrReplaceTempView("ofac")

# Run SQL
with open("sanctioned_uk_ofac.sql", "r") as sqlfile:
    query = sqlfile.read()
result = spark.sql(query)
result.write.csv("output")
