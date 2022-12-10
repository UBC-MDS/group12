# author: Heart Attack Group 12
# date: 2022-11-23

"This script runs data analysis for the preprocessed heart disease data.

Usage: src/data_analysis.r --data_path=<path>

Options:
--data_path=<path> Takes the path to a directory where the pre-processed dataset is stored (this is a required option)
" -> doc

# Libraries & options
library(tidyverse)
library(infer)
library(broom)
library(janitor)

library(docopt)
opt <- docopt(doc)

# load preprocessed data from the input path
heart_data <- read_csv(opt$data_path)

# CODE BELOW ARE NOT FOR PIPELINE
# if one wants to work on the analysis script stand-alone file, then the follow code could be helpful for preprocessing
# heart_data <- read.csv("data/raw/processed.cleveland.csv")
# colnames(heart_data) <- c("age","sex","cp","trestbps","chol","fbs","restecg","thalach","exang","oldpeak","slope","ca","thal","target")
# heart_data <- heart_data |>
#   mutate(target = ifelse(target != 0, 1, 0),
#          ca = as.numeric(ca),
#          thal = as.numeric(thal)) |> 
#   drop_na()

# Convert target to factor
heart_data$target <- as.factor(heart_data$target)
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

# Export all CI and sample estimates in a table as csv for reporting
bootstrap_ci_results <- rbind(age_mean_ci, thalach_mean_ci, oldpeak_median_ci)
write.csv(bootstrap_ci_results, "results/analysis_results/bootstrap_ci_results.csv", row.names = FALSE)


# Next perform the hypothesis testing with permutation
# 1. Age
# H0: means are equal for both groups
# Ha: means for target = 1 is greater than that of target = 0
levels(heart_data$target)
age_delta_star <- diff(age_mean_ci$sample_estimates)
set.seed(12)
age_result <- heart_data |> specify(formula = age ~ target) |> 
  hypothesize(null="independence") |> 
  generate(reps = 5000, type = "permute") |> 
  calculate(stat = "diff in means",
            order = c(1, 0)) |> 
  get_pvalue(obs_stat = age_delta_star, direction = "greater")|> pull()

# 2. thalach
# H0: means are equal for both groups
# Ha: means for target = 1 is lower than that of target = 0
levels(heart_data$target)
thalach_delta_star <- diff(thalach_mean_ci$sample_estimates)
set.seed(12)
thalach_result <- heart_data |> specify(formula = thalach ~ target) |> 
  hypothesize(null="independence") |> 
  generate(reps = 5000, type = "permute") |> 
  calculate(stat = "diff in means",
            order = c(1, 0)) |> 
  get_pvalue(obs_stat = thalach_delta_star, direction = "less")|> pull()

# 3. oldpeak
# H0: means are equal for both groups
# Ha: means for target = 1 is higher than that of target = 0
oldpeak_delta_star <- diff(oldpeak_median_ci$sample_estimates)
set.seed(12)
oldpeak_result <- heart_data |> specify(formula = oldpeak ~ target) |> 
  hypothesize(null="independence") |> 
  generate(reps = 5000, type = "permute") |> 
  calculate(stat = "diff in medians",
            order = c(1, 0)) |> 
  get_pvalue(obs_stat = oldpeak_delta_star, direction = "greater") |> pull()

# Interim conclusion: all tested hypothesis are rejected
variables <- c("age", "thalach", "oldpeak")
estimator <- c("diff in mean", "diff in mean", "diff in median")
H_a <- c("greater", "less", "greater")
target0_estimate <- c(bootstrap_ci_results[[3]][1], bootstrap_ci_results[[3]][3], bootstrap_ci_results[[3]][5])
target1_estimate <- c(bootstrap_ci_results[[3]][2], bootstrap_ci_results[[3]][4], bootstrap_ci_results[[3]][6])
test_statistic <- c(age_delta_star, thalach_delta_star, oldpeak_delta_star)
p_values <- c(age_result,thalach_result,oldpeak_result)

hypothesis_result <- data.frame(variables, estimator, H_a, 
                                target0_estimate, target1_estimate, test_statistic,
                                p_values)
# export for reporting
write.csv(hypothesis_result, "results/analysis_results/hypothesis_result.csv", row.names = FALSE)



# CATEGORICAL VARIABLES
# chi-square testing for the following categorical variables:
# sex
# cp: chest pain type
# fbs: fasting blood sugar > 120 mg/dl
# restecg: resting electrocardiographic results
# exang: exercise induced angina (0 = no, 1 = yes)
# slope: the slope of the peak exercise ST segment
# ca: number of major vessels (0-3) colored by flourosopy
# thal: defect(3 = normal; 6 = fixed defect; 7 = reversable defect)
cont_table_AB <- heart_data %>% tabyl(sex, target)
chisq_result <- tidy(chisq.test(cont_table_AB, correct = FALSE))
cont_table_AB <- heart_data %>% tabyl(cp, target)
chisq_result <- rbind(chisq_result, tidy(chisq.test(cont_table_AB, correct = FALSE)))
cont_table_AB <- heart_data %>% tabyl(fbs, target)
chisq_result <- rbind(chisq_result, tidy(chisq.test(cont_table_AB, correct = FALSE)))
cont_table_AB <- heart_data %>% tabyl(restecg, target)
chisq_result <- rbind(chisq_result, tidy(chisq.test(cont_table_AB, correct = FALSE)))
cont_table_AB <- heart_data %>% tabyl(exang, target)
chisq_result <- rbind(chisq_result, tidy(chisq.test(cont_table_AB, correct = FALSE)))
cont_table_AB <- heart_data %>% tabyl(slope, target)
chisq_result <- rbind(chisq_result, tidy(chisq.test(cont_table_AB, correct = FALSE)))
cont_table_AB <- heart_data %>% tabyl(ca, target)
chisq_result <- rbind(chisq_result, tidy(chisq.test(cont_table_AB, correct = FALSE)))
cont_table_AB <- heart_data %>% tabyl(thal, target)
chisq_result <- rbind(chisq_result, tidy(chisq.test(cont_table_AB, correct = FALSE)))
chisq_result$variable <- c("sex", "chest pain type", "fasting blood sugar level >120mg/dl",
                           "resting electrocardiographic results", "exercise induced angina", 
                           "slope of the peak exercise ST segment", "number of major vessels", 
                           "defect type")
chisq_result <- chisq_result |> select(variable, statistic, p.value) |> 
  mutate(reject0.05 = ifelse(p.value<0.05, 'reject null', 'failed to reject'),
         reject_Bonferroni_corrected = ifelse(p.value<0.05/8, 'reject null', 'failed to reject'),
         p.value = round(p.value, 6),
         statistic = round(statistic, 2))

write.csv(chisq_result, "results/analysis_results/chisq_result.csv", row.names = FALSE)

