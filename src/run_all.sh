# run_all.sh
# Heart attack group 12,  Nov 2022
#
# This script completes analysis of heart-attack
# including data-downloading, preprocessing, EDA,
# hypotheisi testing(feature selection), Model building etc. 
#
# Usage: bash run_all.sh

# download data
python src/download_file.py --url="https://archive.ics.uci.edu/ml/machine-learning-databases/heart-disease/processed.cleveland.data" --out_file="data/raw/processed.cleveland.csv"

# pre-process data 
Rscript src/pre_process_wisc.r --input=data/raw/wdbc.feather --out_dir=data/processed 

# run eda report
python src/EDA_visulization.py --train="data/raw/processed.cleveland.csv" --out_dir="results"

# create exploratory data analysis figure and write to file 
python src/preprocess_heart_disease.py --input_file="data/raw/processed.cleveland.csv" --out_file="data/pre_processed/pre_processed_heart.csv"

# Create analysis in R:
Rscript src/data_analysis.r --data_path="data/pre_processed/pre_processed_heart.csv"

# render final report
Rscript -e "rmarkdown::render('doc/heart_disease_report.Rmd', output_format = 'github_document')