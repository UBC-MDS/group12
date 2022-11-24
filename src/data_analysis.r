"This script runs data analysis for the preprocessed heart disease data.
Usage: data_analysis.r --data_path=<path>
Options:
--data_path=<path> Takes any value (this is a required option)
" -> doc

library(docopt)
opt <- docopt(doc)

# load preprocessed data from the input path
heart_data <- read_csv(opt$path)

# hypothesis testing for numerical variables - using permutation method
library(tidyverse)
library(infer)
options(repr.matrix.max.rows = 6)

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

