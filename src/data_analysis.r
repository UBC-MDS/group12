# "This script runs data analysis for the preprocessed heart disease data.
# Usage: data_analysis.r --data_path=<path>
# Options:
# --data_path=<path> Takes any value (this is a required option)
# " -> doc
# 
# library(docopt)
# opt <- docopt(doc)
# 
# # load preprocessed data from the input path
# heart_data <- read_csv(opt$path)

# Libraries & options
library(tidyverse)
library(infer)
options(repr.matrix.max.rows = 6)


# TO BE DELETED 
heart_data <- read.csv("data/raw/processed.cleveland.csv")
colnames(heart_data) <- c("age","sex","cp","trestbps","chol","fbs","restecg","thalach","exang","oldpeak","slope","ca","thal","target")
heart_data <- heart_data |>
  mutate(target = ifelse(target != 0, 1, 0),
         ca = as.numeric(ca),
         thal = as.numeric(thal)) |> 
  drop_na()

# GLimpse the dataset
summary(heart_data)
# age
# sex
# cp: chest pain type
# trestbps: resting blood pressure (in mm Hg)
# chol: serum cholestoral in mg/dl
# fbs: fasting blood sugar > 120 mg/dl
# estecg: resting electrocardiographic results
# thalach: maximum heart rate achieved
# exang: exercise induced angina (0 = no, 1 = yes)
# oldpeak = ST depression induced by exercise relative to rest
# slope: the slope of the peak exercise ST segment
# ca: number of major vessels (0-3) colored by flourosopy
# thal: defect(3 = normal; 6 = fixed defect; 7 = reversable defect)
# target: diagnosis of heart disease


# NUMERIC VARIABLES
# Hypothesis testing for numerical variables - using permutation method
# Based on EDA results, we will perform the following hypothesis testings
# age, thalach: mean
# oldpeak (skewed distribution, use median)

# First we check the 95% CI of these variables

# bootstrap_ci function
bootstrap_ci <- function(sample, var, stat_type = "mean", level = 0.95){
  set.seed(12)
  boot_sample <- sample |> rep_sample_n(nrow(sample), replace=TRUE, reps = 2000)
  
  if(stat_type == "mean"){
    sample_dist <- boot_sample |> summarise(stat = mean({{var}}))
  } else if (stat_type == "median"){
    sample_dist <- boot_sample |> summarise(stat = median({{var}}))
  } else{
    print("wrong stat type")
  }
  
  sample_dist |> get_confidence_interval(level=level, type = "percentile")
}

# AGE MEAN CI
means <- heart_data |> 
  group_by(target) |> 
  summarise(sample_estimates = round(mean(age), 2)) |> 
  mutate(var_name = rep("age_mean", 2)) |> 
  select(var_name, target, sample_estimates)
ci_estimates <- heart_data |> group_by(target) |> nest() |> 
  mutate(ci = map(data, ~ bootstrap_ci(., age, stat_type ="mean"))) |> 
  unnest(ci) |> select(target, lower_ci, upper_ci) |> 
  mutate(lower_ci = round(lower_ci, 2),
         upper_ci = round(upper_ci, 2))
age_mean_ci <- means |> left_join(ci_estimates)

# thalach MEAN CI
means <- heart_data |> 
  group_by(target) |> 
  summarise(sample_estimates = round(mean(thalach), 2)) |> 
  mutate(var_name = rep("thalach_mean", 2)) |> 
  select(var_name, target, sample_estimates)
ci_estimates <- heart_data |> group_by(target) |> nest() |> 
  mutate(ci = map(data, ~ bootstrap_ci(., thalach, stat_type ="mean"))) |> 
  unnest(ci) |> select(target, lower_ci, upper_ci) |> 
  mutate(lower_ci = round(lower_ci, 2),
         upper_ci = round(upper_ci, 2))
thalach_mean_ci <- means |> left_join(ci_estimates)

# oldpeak MEDIAN CI
medians <- heart_data |> 
  group_by(target) |> 
  summarise(sample_estimates = round(median(oldpeak), 2)) |> 
  mutate(var_name = rep("oldpeak_median", 2)) |> 
  select(var_name, target, sample_estimates)
ci_estimates <- heart_data |> group_by(target) |> nest() |> 
  mutate(ci = map(data, ~ bootstrap_ci(., oldpeak, stat_type ="median"))) |> 
  unnest(ci) |> select(target, lower_ci, upper_ci) |> 
  mutate(lower_ci = round(lower_ci, 2),
         upper_ci = round(upper_ci, 2))
oldpeak_median_ci <- medians |> left_join(ci_estimates)

# Export all CI and sample estimtes in a table as csv for reporting
bootstrap_ci_results <- rbind(age_mean_ci, thalach_mean_ci, oldpeak_median_ci)
write.csv(bootstrap_ci_results,"results.csv", row.names = FALSE)


# Next perform the hypothesis testing with permutation


# CATEGORICAL VARIABLES


# may need wrangling
df <- df %>%
  mutate( click_target = factor(click_target), webpage = factor(webpage))

# NOTE : check 95 % bootstrap CI of the numeric variables of interest

set.seed(522)
age_ci <- heart_data %>%
  filter(webpage == "Interact") %>%
  specify(response = click_target, success = "1") %>%
  generate(reps = 1000, type = "bootstrap") %>%
  calculate(stat = "prop") %>%
  get_ci()

interact_ci$webpage <- "Interact"
interact_ci
(repeat for the other treatment too)
cis <- bind_rows(interact_ci, services_ci)



# chi-square testing for categorical variables

