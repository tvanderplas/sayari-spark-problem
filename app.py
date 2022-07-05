
from pyspark.sql import SparkSession
import os

spark = SparkSession.builder \
    .master("local[1]") \
    .appName("Sayari Spark Task") \
    .getOrCreate()

spark.sparkContext.setLogLevel("WARN")

# Read JSON into dataframes
gbr = spark.read.json(os.path.join("data", "source", "gbr.jsonl.gz"))
ofac = spark.read.json(os.path.join("data", "source", "ofac.jsonl.gz"))
gbr.createOrReplaceTempView("gbr")
ofac.createOrReplaceTempView("ofac")

# Run SQL
with open("sanctioned_uk_ofac.sql", "r") as sqlfile:
    query = sqlfile.read()
result = spark.sql(query)
result.write.csv(os.path.join("data", "output"))
