# Project Proposal

This project attempts to find the association between the probability of heart attack and various demographic or medical factors of the patient.

### Contributors:
- Kelly Wu
- Bruce Wu
- Zilong Yi
- Stepan Zaiatc

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

### Research Question & Planned Analysis
We are going to use hypothesis testing to investigate a few factors that could possibly associates with having higher probability of heart attack.
- Do people with higher probability of heart attack and people with lower probability of heart attack have the equal cholestoral level or inequal cholestoral level? To answer this question, we will first investigate the central tendency of cholestoral level of the two groups by estimating the average cholestoral level with sample means. We will use bootstrapping method to provide precision measure for our estimate. Then we will conduct one-sided hypothesis testing with permutation to test our hypothesis. Our null hypothesis is that the average cholestoral levels are the same between people with lower probability and higher probability of heart attack. Our alternative hypothesis is that the average cholestoral levels is higher for people with higher probability of heart attack than that of people with lower probability of heart attack.

** note: in EDA if we find any factor that seems to have association between heart attack we can switch to that factor.

- We could also explore another factor in this dataset: fasting blood sugar > 120 mg/dl. The question we want to answer is that if fasting blood sugar > 120 mg/dl is associated with lower or higher probability of heart attack. We will conduct chi-square test of independence to see if this factor impact the probability.


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

#### References

Dua, Dheeru, and Casey Graff. 2019. “UCI Machine Learning Repository.” University of California, Irvine, School of Information; Computer Sciences. http://archive.ics.uci.edu/ml.
