# author: Heart Attack Group 12
# date: 2022-11-23

"""
"The script cleans and pre-processes the Heart Disease dataset 
(from https://archive.ics.uci.edu/ml/machine-learning-databases/heart-disease/#:~:text=processed.cleveland.data).
This script writes out cleaned and processed output file to a separate csv files.

Usage: src/preprocess_heart_disease.py --input_file=<input_file> --out_file=<out_file>

Example: 
python src/preprocess_heart_disease.py --input_file="data/raw/processed.cleveland.csv" --out_file="data/pre_processed/pre_processed_heart.csv"
  
Options:
--input_file=<input_file>       Path (including filename) to raw data file in csv format
--out_file=<out_file>             Path to a directory where the processed file should be written to (including the format of the file)
"
"""

# importing required libraries
from docopt import docopt
import numpy as np
import pandas as pd
import os


#initializing docopt
opt = docopt(__doc__)


#function to read and clean the data 
def main(input_file, out_file):

    """
    This main will read the dataset from path that contains raw data file.
    Parameters
    ----------
    input_file : str
        Path to a raw data file to be processed.
    out_file : str
        The path to where to process the file.
    """

    # read data and convert raw data file
    heart_raw = pd.read_csv(input_file)

    # re-naming the header columns
    heart_modified = heart_raw.rename(
        columns={"0": "age", "1":"sex", "2":"cp", "3":"trestbps", "4":"chol", 
        "5":"fbs", "6":"restecg", "7":"thalach", "8":"exang", "9":"oldpeak", 
        "10":"slope", "11":"ca", "12":"thal", "13":"target"})

    # creating a new binary target variable where 1 is a positive class
    heart_modified.loc[(heart_modified.target != 0),'target']=1


    # replacing all of the "?"" values with NaN
    heart_clean = heart_modified.replace('?', np.nan)

    # dropping all of the rows that contain missing values
    heart_clean = heart_clean.dropna()
    
    # converting columns to desired data type
    heart_clean['ca'] = heart_clean['ca'].astype(float)
    heart_clean['thal'] = heart_clean['thal'].astype(float)

    # writing out a processed file in a csv format
    os.makedirs(os.path.dirname(out_file))
    heart_clean.to_csv(out_file, index = False)

if __name__ == "__main__":
    main(opt["--input_file"], opt["--out_file"])