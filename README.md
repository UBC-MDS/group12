# Inferential analysis of factors related to presence of heart disease


### Summary

In this project we attempt to find the association between the probability of heart disease and various demographic or health factors of the patients including age, sex, chest pain type, cholesterol levels etc. We perform hypothesis testing using permutation test for numerical variables such as age, the maximum heart rate achieved, and ST depression induced by exercise relative to rest which is considered a proven ECG finding for obstructive coronary atherosclerosis (Lanza et al., 2004). ECG, or electrocardiography, is a test that measures the electrical activity of the heart. ST depression is a term used to describe a specific pattern seen on an ECG, which can be a sign of heart disease. Our original data set also included some categorical variables that we use to conduct our hypothesis testing using Chi-Squared Test in the analysis of contingency tables.

We conclude that people with heart disease will have higher average age, lower maximum heart rate achieved, and higher ST depression induced by exercise relative to rest comparing to people without heart disease. ST depression is characterized by the the ST segment on electrocardiogram (ECG) appearing abnormally low sitting below the baseline. ST depression can occur due to severe complications with heart. We also found that sex, chest pain type, exercise induced angina which is a type of chest pain that is brought on by stress, slope of the peak exercise ST segment, number of major vessels, and defect type are associated with presence of heart disease.

### Contributors:
- Kelly Wu
- Bruce Wu
- Zilong Yi
- Stepan Zaiatc

### Report

Final report can be found [here](https://htmlpreview.github.io/?https://github.com/UBC-MDS/heart_attack_gr12/blob/main/doc/heart_disease_report.html)

### Usage 
Here is an overview of our reporsitory's file structure.
![Alt text](https://github.com/UBC-MDS/inferential_study_heart_attack/blob/main/results/Heart%20attack.png)

#### Option 1: Reproduce the analysis with Docker
To run this analysis using Docker, clone/download this repository, use the command line to navigate to the root of this project on your computer, and then type the following (filling in PATH_ON_YOUR_COMPUTER with the absolute path to the root of this project on your computer, or $PWD if you are already in the project directory).

This command will pull the docker image kellywujy/tidyinferential from docker hub, create the container, and run makefile inside the container. 

NOTE: RUN ONE OF THE FOLLOWING COMMAND, DEPENDING ON YOUR PROCESSOR


**If you use Intel processors - amd64, please run this**
```
docker run --rm -v PATH_ON_YOUR_COMPUTER:/home/data_analysis kellywujy/tidyinferential make -C /home/data_analysis all
```

**If you use Mac M1/M2 (Apple silicon - arm64), please run this**
```
docker run --rm --platform linux/amd64 -v PATH_ON_YOUR_COMPUTER:/home/data_analysis kellywujy/tidyinferential make -C /home/data_analysis all
```

To clean up the analysis type:
```
docker run --rm -v PATH_ON_YOUR_COMPUTER:/home/data_analysis kellywujy/tidyinferential make -C /home/data_analysis clean
```

#### Option 2: Reproduce the analysis with Makefile or shell script
In order to reproduce the analysis, clone the repository, install [dependencies](#dependencies) listed below, (or if you use conda, using [enviroment.yml](https://github.com/UBC-MDS/heart_attack_gr12/blob/main/environment.yml) to install corresponding packages), and run the following commands in the command line/terminal from the root directory of this project one by one, or just run `run_all.sh` file:

One-by-One
```
# download data
python src/download_file.py --url="https://archive.ics.uci.edu/ml/machine-learning-databases/heart-disease/processed.cleveland.data" --out_file="data/raw/processed.cleveland.csv"

# pre-process data 
python src/preprocess_heart_disease.py --input_file="data/raw/processed.cleveland.csv" --out_file="data/pre_processed/pre_processed_heart.csv" 

# run eda report
python src/EDA_visulization.py --train="data/raw/processed.cleveland.csv" --out_dir="results"

# create exploratory data analysis figure and write to file 
python src/preprocess_heart_disease.py --input_file="data/raw/processed.cleveland.csv" --out_file="data/pre_processed/pre_processed_heart.csv"

# Create analysis in R:
Rscript src/data_analysis.r --data_path="data/pre_processed/pre_processed_heart.csv"

# render final report
Rscript -e "rmarkdown::render('doc/heart_disease_report.Rmd', output_format = 'github_document')
```

All at once:
```
# This script completes analysis of heart-attack
# including data-downloading, preprocessing, EDA,
# hypotheisi testing(feature selection), Model building etc. 

make all
```

Run the following command at the command line or terminal from the root directory of this project to reset the repository to a clean state with no intermediate or results files:
```
make clean
```


### Dataset

The dataset used in this project is the heart disease data set from the UCI machine learning repository. The original unprocessed source data files includes 76 features about the patents from 4 regions (Cleveland, Hungary, Switzerland, and the VA Long Beach). The unprocessed data contains lots of unidentified values, missing values and uncleaned data for many features. Among the data files from the 4 regions, only the data from Cleveland has been partially cleaned and became widely used by the data science community. The Cleveland data set we are dealing with still contains some missing values that will be imputed with 'NaN' and subsequently dropped during the pre-processing phase of this project. The source data set was created by Robert Detrano at V.A. Medical Center, Long Beach and Cleveland Clinic Foundation. The cleaned Cleveland data is sourced from the UCI machine learning repository (Dua and Graff 2017) and can be found [here](https://archive.ics.uci.edu/ml/machine-learning-databases/heart-disease/processed.cleveland.data). 
This data set contains 14 features that deemed to be relevant by the ML researchers. In this project, we will use partially cleaned Cleveland data set containing some missing values to conduct an inferential study on factors that could be associated with presence of heart disease. The data set would initially need to be pre-processed and cleaned further into the usable format.

### Research Question & Planned Analysis

Our research question: what factor(s) are associated with presence of heart disease? This is an inferential research question. To answer this question, we will need to answer a following sub-questions:
- Does any numerical feature distribute differently between people with and without heart disease?
- Does any categorical feature is frequently occurred among people with heart disease?
- Do we have statistically significant evidence to state that the observed trend is not due to chance?
- If we do find a factor that shows statistical significance, how large is its effect on the probability of presence of heart disease? 

We have the following columns available from the dataset :
1. age: This is the age of the study participant. 
2. sex: This is the gender of the study participant, with 1 representing male and 0 representing female. 
3. cp: This stands for "chest pain type," and is a measure of the type of chest pain the participant experiences. It is an ordinal variable with the following possible values:
      0: asymptomatic
      1: atypical angina
      2: non-anginal pain
      3: typical angina
4. trestbps: This stands for "resting blood pressure," which is the blood pressure measured after the person has been sitting or lying down for a few minutes. It is a measure of the pressure of the blood against the walls of the arteries.
5. chol: This stands for "serum cholesterol," which is a measure of the amount of cholesterol in the blood. Cholesterol is a type of fat that is essential for the proper function of the body, but high levels of cholesterol in the blood can increase the risk of heart disease.
6. fbs: This stands for "fasting blood sugar," which is a measure of the amount of sugar (glucose) in the blood after the person has fasted for at least 8 hours. It is used to diagnose diabetes and to monitor blood sugar control in people with diabetes.
7. restecg: This stands for "resting electrocardiography," which is a test that records the electrical activity of the heart. It is often used to diagnose heart conditions, such as arrhythmias (abnormal heart rhythms) or to assess the overall health of the heart.
8. thalach: This stands for "maximum heart rate achieved," which is the highest heart rate a person reaches during exercise. It is often used to assess a person's cardiovascular fitness.
9. exang: This stands for "exercise-induced angina," which is chest pain that occurs during or after physical activity. It is often a sign of underlying heart disease. This variable is binary, with 0 representing no exercise-induced angina and 1 representing exercise-induced angina.
10. oldpeak: This is the "ST depression induced by exercise relative to rest," which is a measure of the change in the electrical activity of the heart during exercise compared to when the person is at rest. A large depression can be a sign of heart disease.
11. slope: This is the "slope of the peak exercise ST segment," which is a measure of the shape of the segment of the electrocardiogram (ECG) that represents the heart's electrical activity during exercise.
12. ca: This stands for "number of major vessels (0-3) colored by flourosopy," which is a measure of the number of major blood vessels that are visible on a medical imaging test called flourosopy.
13. thal: This stands for "defect," which is a measure of the presence of a heart defect. It is an ordinal variable with the following possible values:
      3: normal
      6: fixed defect
      7: reversible defect
14. target: This is the "diagnosis of heart disease" and is the binary outcome variable, with 0 representing no heart disease and 1 representing heart disease.

Our planned analysis includes the following steps and methods. 

During EDA, We will visualize the numerical features with overlaying histograms to compare the distribution of these features between the two groups. We will compare the summary statistics (e.g. mean, standard deviation) of numeric features between the two groups. We will also examine the correlation between each pair of numerical features to get an idea of it colinearity would affect the investigation later on. 

Also, for categorical features, we will do cross-tabulations to see the frequency of each categories between the two groups. We will also create bar charts to visualize if any category is often frequently occur in the group with heart disease.

With EDA, we would be able to get an idea of which factors to further examine.

Our analysis will be driven by the observations we found during exploratory data analysis (EDA file available [here](https://github.com/UBC-MDS/inferential_study_heart_attack/blob/main/doc/EDA_heart_disease.ipynb).

In later analysis, we are going to conduct hypothesis testing to investigate a the identified potentially factors that could possibly associates with presence of heart attack. Specifically, 
- For numeric features, we will first check the central tendency, then conduct hypothesis testing. For example, maximum heart rate achieved is an variable of interest. We will first investigate the central tendency of maximum heart rate achieved of the two groups by estimating the average with sample means. We will also use bootstrapping method to provide precision measure for our estimate. Then we will conduct one-sided hypothesis testing with permutation to test our hypothesis. Our null hypothesis is that the average maximum heart rate achieved are the same between people with heart disease and without heart disease. Our alternative hypothesis is that the average maximum heart rate achieved is lower for people with heart disease than that of people without heart disease.
- For categorical features, we could conduct Chi-square test to see if the factor and the presence of heart disease are independent. 


### Sharing the results
We will conduct the analysis in Jupyter notebook format and publish the result on GitHub for open access. Our repository would contain the raw data file, the .ipynb notebook that includes all the technical details on how the analysis evolved throughout the process, and a final report that summarize the major findings and reports the our conclusion. 

We will document our thinking process and the method of our analysis in the notebook using markdown and code comments to sure that our analysis is reproducible and auditable.

In the final report, we will convey the major finding with a table of summary statistics (sample mean, standard error, 95% boootstrap CI) as long as the hypothesis test results (test statistics, p-values). Also, histograms and bar charts will be provided in the report to visualize how the distribution varies between the two group of patients.

## Dependencies

Note on reproducing the analysis: our the analysis is conducted with the following packages.

#### Python 3.10.6 and Python packages:

- dataframe-image==0.1.3

- docopt==0.7.1

- altair_saver==0.1.0

- pandas==1.5.1

- ipython==7.10.1

- dataframe-image==0.1.3

- seaborn==0.12.1

#### R version 4.2.1 and R packages:

- knitr==1.40

- tidyverse==1.3.2

- ggplot2==3.3.6

- kableExtra==1.3.4

- infer==1.0.3

- janitor==2.1.0

- docopt==0.7.1

- here==1.0.1



### Licences
The materials of this inferential analysis on factors relate with presence of heart disease here are licensed under the Creative Commons Attribution-NonCommercial-NoDerivatives 4.0 International License. If re-using/re-mixing please provide attribution and link to this webpage.

## References

Dua, Dheeru, and Casey Graff. 2019. “UCI Machine Learning Repository.” University of California, Irvine, School of Information; Computer Sciences. http://archive.ics.uci.edu/ml.

Lanza, Gaetana A., et al. "Diagnostic and prognostic value of ST segment depression limited to the recovery phase of exercise stress test." Heart 90.12 (2004): 1417-1421.
