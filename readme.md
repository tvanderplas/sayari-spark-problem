# Sayari Spark Problem

My solution to [this problem](https://gist.github.com/jvani/0bc9a6aa143c5cc8bdd74f6b3828faac).

## How to Run

1. Download the project
2. Create a python environment and install requirements
3. From project root, run `spark-submit --master local app.py`
4. The result will be a csv file in the `data/output` folder

## Initial Observations

Reading the json to dataframes reveals 2 datasets with very similar structure:

<diagram1.png>

The OFAC dataset is larger than GBR and contains more record types:

|            | OFAC |  GBR |
|------------|------|------|
| Individual | 4543 | 1638 |
|     Entity | 3616 |  575 |
|   Aircraft |  277 |    0 |
|     Vessel |  403 |    0 |
|  **Total** | 8839 | 2213 |

## Approach

Identify fields that make sense as identifiers and use them to compare lists. 

## Notes

 * Some names appear more than once within both datasets. Since the duplicates all appear to refer to the same individual or entity, I decided not to exclude them from the results. 
