#!/bin/bash

# values to change
f="ATTRIBUTE_adv_fibrosis"
dp=0.6
lr=0.001
e=5000

folder="f_${f}_dp_${dp}_lr_${lr}_e_${e}"
echo $folder
### Check if a directory exists ###
if [ -d "./songbird_traintest_7030/$folder/" ] 
then
    echo "Directory /$folder exists."
# create new directory if not 
else
    mkdir "./songbird_traintest_7030/$folder/"
fi

# create songbird model using specified f, dp, lr
qiime songbird multinomial \
	--i-table ../feature_tables/serum-ft-hashed-matched.qza \
	--m-metadata-file ../../metadata-matched-sb.tsv \
	--p-formula "${f}" \
	--p-differential-prior "${dp}" \
	--p-epochs "${e}" \
	--p-learning-rate "${lr}" \
	--p-summary-interval 1 \
	--p-training-column sb_train_test \
	--o-differentials "./songbird_traintest_7030/${folder}/differentials.qza" \
	--o-regression-stats "./songbird_traintest_7030/${folder}/regression-stats.qza" \
	--o-regression-biplot "./songbird_traintest_7030/${folder}/regression-biplot.qza" \

# create songbird null model
qiime songbird multinomial \
	--i-table ../feature_tables/serum-ft-hashed-matched.qza \
	--m-metadata-file ../../metadata-matched-sb.tsv \
	--p-formula "1" \
	--p-epochs "${e}" \
	--p-differential-prior "${dp}" \
	--p-learning-rate "${lr}" \
	--p-summary-interval 1 \
	--p-training-column sb_train_test \
	--o-differentials "./songbird_traintest_7030/${folder}/null-diff.qza" \
	--o-regression-stats "./songbird_traintest_7030/${folder}/null-stats.qza" \
	--o-regression-biplot "./songbird_traintest_7030/${folder}/null-biplot.qza"

# Visualize the first model's regression stats *and* the null model's
# regression stats
qiime songbird summarize-paired \
	--i-regression-stats "./songbird_traintest_7030/${folder}/regression-stats.qza" \
	--i-baseline-stats "./songbird_traintest_7030/${folder}/null-stats.qza" \
	--o-visualization "./songbird_traintest_7030/${folder}/paired-summary.qzv"