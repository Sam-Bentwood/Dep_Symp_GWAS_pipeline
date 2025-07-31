#!/bin/bash
#$ -N regenie_step2
#$ -l h_rt=24:00:00
#$ -l h_vmem=8G
#$ -pe sharedmem 16
#$ -e logs
#$ -o logs
#$ -M s2568256@ed.ac.uk
#$ -m baes

## REGENIE STEP 2 - a set of imputed SNPs are tested for association using a linear regression model
# Regenie handles relatedness so please retain related individuals in your data

# This is an example script in the UKB cohort, and assumes regenie was installed previously via Conda/Anaconda (Please edit for your data and computing set-up).
# To install regenie via conda, start conda/anaconda however you normally load programmes (e.g., module load anaconda) and then submit the following command:
# conda create -n regenie_env -c conda-forge -c bioconda regenie

# For troubleshooting see the REGENIE documentation: https://rgcgithub.github.io/regenie/options/

# Load environment modules - this line allows the anaconda module to be loaded after
. /etc/profile.d/modules.sh
 
# Load regenie conda environment
module load anaconda
conda activate regenie_env


# Specify file paths and ancestry code
IMPUTED=/gpfs/igmmfs01/eddie/GenScotDepression/data/ukb/genetics/impv3_pgen
PHENO=/gpfs/igmmfs01/eddie/GenScotDepression/users/sam/Projects/dep_symp/Data/Phenotypes/UKB
STAGING=/gpfs/igmmfs01/eddie/GenScotDepression/users/sam/Projects/dep_symp/Data/GWAS/UKB/REGENIE_staging
ANS=SAS

# Loop through imputed chromosomes and run step 2
# This code loops through Chromosomes sequentially, if desired then some form of parallelisation could be worthwhile
for CHR in {1..22}; do
    regenie \
        --step 2 \
        --pgen $IMPUTED/ukb_imp_v3.qc \
        --chr $CHR \
        --phenoFile $PHENO/dep_score_stand_mean.txt \
        --covarFile $PHENO/covariates.txt \
        --covarCol PC{1:6},yob \
        --catCovarList sex,genotyping \
        --bsize 400 \
        --minMAC 20 \
        --minINFO 0.1 \
        --qt \
        --pred $STAGING/stage1_${ANS}_pred.list \
        --out $STAGING/stage2_${ANS}_chr${CHR} \
        --threads 16

done

## You will then need to merge the output (all chromosomes into one file) - see step 4.merge_output.sh

# --pgen = path to imputed data. Here we use the .pgen format, so use the pgen flag and point to file prefix for .pgen/.psam/.pvar files. See REGENIE documention for more info on file input
# --chr = chromosome number - if you have bgen files split by chromosome then you will omit this flag and chromosome number will be specified in the path in --bgen flag
# --phenoFile = path to your phenotype file with the header FID IID pheno_col 
# --phenoCol = phenotype column name - not needed if only analysing one phenotype and phenoFile only contains three columns as above
# --covarFile = covariate file path with the header FiD IID C1 C2 C3 etc.
# --catCovarList = list of categorical covariates in the covarFile
# --covarCol = numeric covariate column names - only needed if you have numeric columns in covarFile you want to be ignored. Otherwise regenie uses all columns except the ones listed as categorical 
# --bsize = chunk size for analysis
# --minMAC = minimum minor allele count
# --minINFO = minimum imputation info score
# --qt = specifies quantitative trait
# --pred = path to file containing predictions from STEP 1
# --out = path to output file(s)
# --threads = for parallel processing with multiple cores - here we've set threads equal to number of cores requested for job