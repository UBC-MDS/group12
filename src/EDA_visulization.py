# author: Bruce Wu
# date: 2022-11-25

"""
"The script performs some explanatory data analysis and creates some correponding tables and figures.
Saves the plots as a pdf and png file.
Usage: src/EDA_visulization.py --train=<train> --out_dir=<out_dir>

Example: 
python src/EDA_visulization.py --train="data/raw/processed.cleveland.csv" --out_dir="results"
  
Options:
--train=<train>     Path (including filename) to training data 
--out_dir=<out_dir> Path to directory where the plots should be saved
" 
  
"""
# Imports
from docopt import docopt
import matplotlib.pyplot as plt
import numpy as np
import altair as alt
import pandas as pd
import os
from pandas.plotting import table 
import dataframe_image as dfi
import seaborn as sns

# Include an image for each plot since Gradescope only supports displaying plots as images
alt.renderers.enable('mimetype')

# initializing docopt
opt = docopt(__doc__)

# function to visualize 
def main(train, out_dir):
    # read data and convert raw data file
    data=pd.read_csv(train,
                names=["age","sex","cp","trestbps","chol","fbs","restecg","thalach","exang","oldpeak","slope","ca","thal","target"],skiprows=1)

    # some preprocessing to perform EDA
    data.loc[(data.target != 0),'target']=1
    data.loc[(data.ca == "?"),'ca']=np.nan
    data.loc[(data.thal == "?"),'thal']=np.nan
    data.dropna()
    data['ca'] = data['ca'].astype(float)
    data['thal'] = data['thal'].astype(float)

    # table of the first five rows of the data
    dfi.export(data.head(), out_dir + '/head.png')
    
    # examining numeric features
    num_cols = ["age", "trestbps", "chol", 'thalach','oldpeak']
    less_prob = data.query("target==0")[num_cols].describe()
    more_prob = data.query("target==1")[num_cols].describe()
    dfi.export(less_prob, out_dir + '/low.png')
    dfi.export(more_prob, out_dir + '/high.png')
    
    # numeric features plot
    fig, axs = plt.subplots(nrows=3, ncols=2, figsize=(10, 10))
    for col, ax in zip(num_cols, axs.ravel()):
        data.groupby("target")[col].plot.hist(ax = ax, bins=10, alpha=0.5, legend=True,title='Histogram of ' + col)
        ax.set_xlabel(col,loc="left")
    txt="Histograms of numeric values. We observed that higher age, lower maximum heart rate achieved (thalac) \
         \n and higher ST depression induced by exercise relative to rest (oldpeak) seems to be more frequent in the people with diagnosed heart disease"
    plt.figtext(0.5, 0.01, txt, wrap=True, horizontalalignment='center', fontsize=12)
    plt.savefig(out_dir + "/numeric.jpg")
    
    
    # correlation of numeric features
    corr=data[["age","trestbps","chol","thalach","oldpeak","target"]].corr().style.background_gradient()
    dfi.export(corr,  out_dir + "/corr.png")
    
    #categorical features plot(only significant features)
    fig, axs = plt.subplots(nrows=2, ncols=2, figsize=(10,10))
    categorical_features = ["cp","exang","slope","ca","thal"]
    for col, ax in zip(categorical_features, axs.ravel()):
              data.groupby("target")[col].plot.hist(ax = ax, bins=10, alpha=0.5, legend=True
                                               ,title='Histogram of ' + col)
              ax.set_xlabel(col,loc="left")
    txt="Histograms of categorical values. We observed that some categorical variables with certain values have some relationship with the  \
         \n probability of heart attack and we will discuss them later."
    plt.figtext(0.5, 0.01, txt, wrap=True, horizontalalignment='center', fontsize=12)   
    plt.savefig(out_dir + "/categorical.jpg")
    

if __name__ == "__main__":
    main(opt["--train"], opt["--out_dir"])