# Heart Attack data pipe
# author: Kelly Wu, Bruce Wu, Stepan Zaitac, Zilong Yi
# date: 2022-12-02

all: data/raw/processed.cleveland.csv data/pre_processed/pre_processed_heart.csv results/categorical.jpg results/corr.ppg results/head.png results/high.png results/low.png results/numerical.jpg results/bootstrap_ci_results.csv results/chisq_result.csv results/hypothesis_result.csv doc/heart_disease_report.html

# download data
data/raw/processed.cleveland.csv: src/download_file.py
	python src/download_file.py --url="https://archive.ics.uci.edu/ml/machine-learning-databases/heart-disease/processed.cleveland.data" --out_file="data/raw/processed.cleveland.csv"

# pre-process data
data/pre_processed/pre_processed_heart.csv:src/preprocess_heart_disease.py data/raw/processed.cleveland.csv
	python src/preprocess_heart_disease.py --input_file="data/raw/processed.cleveland.csv" --out_file="data/pre_processed/pre_processed_heart.csv"


# exploratory data analysis - visualize predictor distributions across classes
results/categorical.jpg results/corr.ppg results/head.png results/high.png results/low.png results/numerical.jpg:data/raw/processed.cleveland.csv src/EDA_visulization.py
	python src/EDA_visulization.py --train="data/raw/processed.cleveland.csv" --out_dir="results"

# Analysis in R
results/bootstrap_ci_results.csv results/chisq_result.csv results/hypothesis_result.csv: data/pre_processed/pre_processed_heart.csv src/data_analysis.r
	Rscript src/data_analysis.r --data_path="data/pre_processed/pre_processed_heart.csv"

# render report
doc/heart_disease_report.html heart_disease_report.md: doc/heart_disease_report.Rmd doc/heart_disease_refs.bib
	Rscript -e "rmarkdown::render('doc/heart_disease_report.Rmd', output_format = 'github_document')"

clean: 
	rm -rf data
	rm -f results/*.jpg
	rm -rf results/head.png results/high.png results/low.png results/corr.png
	rm -rf doc/heart_disease_report.html doc/heart_disease_report.md
	rm -rf results/bootstrap_ci_results.csv results/chisq_result.csv results/hypothesis_result.csv