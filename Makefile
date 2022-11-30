# Makefile
#Group number: 7
# Date: 2022-11-29

all :  data/raw/risk_factors_cervical_cancer.csv data/processed/train.csv results/binary_feat.png results/cv-results.csv results/pr_curve_logreg.png Analysis_Docs/Analysis.html

#download the data
data/raw/risk_factors_cervical_cancer.csv:	src/download_data_script.py	
	python src/download_data_script.py --url="https://archive.ics.uci.edu/ml/machine-learning-databases/00383/risk_factors_cervical_cancer.csv" --output_file="risk_factors_cervical_cancer.csv"

#preprocess the data
data/processed/train.csv data/processed/test.csv:	src/preprocess_cervical_cancer.py data/raw/risk_factors_cervical_cancer.csv
	python src/preprocess_cervical_cancer.py --input_file="data/raw/risk_factors_cervical_cancer.csv" --out_dir="data/processed"

#eda of training data
results/binary_feat.png results/numeric_feat.png results/smoke_corr.csv results/std_corr.csv:	src/eda_figures.py data/processed/train.csv
	python src/eda_figures.py --train_data='data/processed/train.csv' --out_file='results'

#creates optimised model for the training data
results/cv-results.csv results/mean-cv-results.csv: src/model_training.py data/processed/train.csv
	python src/model_training.py --data_path='data/processed/train.csv' --output_path_cv='results'


#creates optimised model for the training data
results/pr_curve_logreg.png results/pr_curve_nb.png results/pr_curve_rfc.png results/pr_curve_svc.png results/test-results.csv: src/model_testing.py data/processed/test.csv
	python src/model_testing.py --data_path='data/processed/test.csv' --output_path='results'

# render report
Analysis_Docs/Analysis.html: Analysis_Docs/Analysis.Rmd Analysis_Docs/ref.bib
	Rscript -e "rmarkdown::render('Analysis_Docs/Analysis.Rmd')"


clean: 
	rm -rf data
	rm -rf results
    rm -rf Analysis_Docs/Analysis.html