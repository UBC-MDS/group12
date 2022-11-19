# Project Proposal

This project attempts to find the association between the probability of heart attack and various demographic or medical factors of the patient. We attempt to use hypothesis testing on several demographic and medical factors between people who are not diagnosed with heart disease and those who are diagnosed with heart disease to make inference on whether certain factor are associated with presence of heart disease. 

### Contributors:
- Kelly Wu
- Bruce Wu
- Zilong Yi
- Stepan Zaiatc

## Dataset

The dataset used in this project is the heart disease data set from the UCI machine learning repository. The original unprocessed source data files includes 76 features about the patents from 4 regions (Cleveland, Hungary, Switzerland, and the VA Long Beach). The unprocessed data contains lots of unidentified values, missing values and uncleaned data for many features. Among the data files from the 4 regions, only the data from Cleveland has been cleaned and became widely used by the data science community. The source dataset was created by Robert Detrano at V.A. Medical Center, Long Beach and Cleveland Clinic Foundation. The cleaned Cleveland data is sourced from the UCI machine learning repository (Dua and Graff 2017) and can be found [here](https://archive.ics.uci.edu/ml/machine-learning-databases/heart-disease/processed.cleveland.data). 
This dataset contains 14 features that deemed to be relevant by the ML researchers. In this project, we will use the cleaned and processed Cleveland data set to conduct an inferential study on factors that could be associated with presence of heart disease. 

The python script for downloading the database is located in the src folder of this repository. To replicate this analysis, clone this GitHub repository (git clone), install the dependencies listed below in the "Dependencies" section, and run the following commands at the command line from the root directory of this project:

```
python src/download_file.py --url="https://archive.ics.uci.edu/ml/machine-learning-databases/heart-disease/processed.cleveland.data" --out_file="data/raw/processed.cleveland.csv"
```

### Research Question & Planned Analysis
We are going to use hypothesis testing to investigate a few factors that could possibly associates with presence of heart attack. 
We have the following columns available from the dataset:
- 1.age 
- 2.sex
- 3. cp: chest pain type 
- 4. trestbps: resting blood pressure (in mm Hg)
- 5. chol: serum cholestoral in mg/dl
- 6. fbs: fasting blood sugar > 120 mg/dl
- 7. estecg: resting electrocardiographic results
- 8. thalach: maximum heart rate achieved
- 9. exang: exercise induced angina (0 = no, 1 = yes)
- 10. oldpeak = ST depression induced by exercise relative to rest
- 11. slope: the slope of the peak exercise ST segment
- 12. ca: number of major vessels (0-3) colored by flourosopy
- 13. thal: defect(3 = normal; 6 = fixed defect; 7 = reversable defect)
- 14. target: diagnosis of heart disease

Our analysis is driven by the observations we found during exploratory data analysis (EDA file available [here](https://github.com/UBC-MDS/heart_attack_gr12/blob/main/doc/EDA_group_12.ipynb).

When comparing the summary statistics between the people with heart disease and people without heart disease, we noticed that


, we observed that 
The following are the factor of interest and the analysis we are going to conduct using the dataset. 
- Do people with higher probability of heart attack and people with lower probability of heart attack have the equal cholestoral level or inequal cholestoral level? To answer this question, we will first investigate the central tendency of cholestoral level of the two groups by estimating the average cholestoral level with sample means. We will use bootstrapping method to provide precision measure for our estimate. Then we will conduct one-sided hypothesis testing with permutation to test our hypothesis. Our null hypothesis is that the average cholestoral levels are the same between people with lower probability and higher probability of heart attack. Our alternative hypothesis is that the average cholestoral levels is higher for people with higher probability of heart attack than that of people with lower probability of heart attack.

** note: in EDA if we find any factor that seems to have association between heart attack we can switch to that factor.

- We could also explore another factor in this dataset: fasting blood sugar > 120 mg/dl. The question we want to answer is that if fasting blood sugar > 120 mg/dl is associated with lower or higher probability of heart attack. We will conduct chi-square test of independence to see if this factor impact the probability.


### Render jupyter notebook
By downloading the database, the EDA file is in doc/EDA_group_12.ipynb, please open the file and run all the cells.

## Dependencies

#### Python 3.10.6 and Python packages:

- docopt==0.7.1

- altair_saver==0.1.0

- pandas==1.5.1

- ipython==7.10.1

#### R version 4.2.1 and R packages:

- knitr==1.40

- tidyverse==1.3.2

- ggplot==3.3.6

### Dataset
**Heart Attack Dataset from the UCI Machine Learning Repository. Center for Machine Learning and Intelligent Systems.**

https://archive.ics.uci.edu/ml/machine-learning-databases/heart-disease/




### EDA
table
- sample min, max, median, mean, sd for each factor.
- histogram for each numeric factor.
- bar plot for each categorical factor.

figure 
- for cholestoral level (numeric var) boxplot + individual observations in grey marks. comparing the two groups
- for exercise: bubble chart


### 5. Sharing the results
We will conduct the analysis in Jupyter notebook format and publish the result on GitHub for open access. Our repository would contain the raw data file, the .ipynb notebook that includes all the technical details on how the analysis evolved throughout the process, and a final report that summarize the major findings and reports the our conclusion. 

We will document our thinking process and the method of our analysis in the notebook using markdown and code comments to sure that our analysis is reproducible and auditable.

### Licences
The ___ materials here are licensed under the ____ (e.g. Creative Commons Attribution 2.5 Canada License (CC BY 2.5 CA)). If re-using/re-mixing please provide attribution and link to this webpage.

## References

Dua, Dheeru, and Casey Graff. 2019. “UCI Machine Learning Repository.” University of California, Irvine, School of Information; Computer Sciences. http://archive.ics.uci.edu/ml.
