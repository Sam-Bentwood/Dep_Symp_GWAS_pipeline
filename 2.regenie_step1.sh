#!/bin/bash
#$ -N regenie_step1
#$ -l h_rt=24:00:00
#$ -l h_vmem=8G
#$ -pe sharedmem 16
#$ -e logs
#$ -o logs
#$ -M s2568256@ed.ac.uk
#$ -m baes

## REGENIE STEP 1 - whole genome regression model is fit to the traits, and a set of genomic predictions are produced as output. 
# Regenie handles relatedness so please retain related individuals in your data
# This is an example script in the UKB cohort, and assumes regenie installation using Conda. Please edit for your data and computing set-up

# Load environment modules
. /etc/profile.d/modules.sh
 
# Load regenie conda environment
module load anaconda
conda activate regenie_env

# Specify file paths and ancestry code
GENO_FULL=/gpfs/igmmfs01/eddie/GenScotDepression/data/ukb/genetics/impv2/bfile/autosome
GENO_QC=/gpfs/igmmfs01/eddie/GenScotDepression/users/sam/Projects/dep_symp/Data/Genotypes/UKB/whole_genome
PHENO=/gpfs/igmmfs01/eddie/GenScotDepression/users/sam/Projects/dep_symp/Data/Phenotypes/UKB
STAGING=/gpfs/igmmfs01/eddie/GenScotDepression/users/sam/Projects/dep_symp/Data/GWAS/UKB/REGENIE_staging
ANS=SAS


## Step 1 is performed on the genotyped data
regenie \
  --step 1 \
  --qt \
  --bed $GENO_FULL/autosome \
  --extract $GENO_QC/QC_pass_$ANS.snplist \
  --keep $GENO_QC/QC_pass_$ANS.id \
  --phenoFile $PHENO/dep_score_stand_mean.txt \
  --covarFile $PHENO/covariates.txt \
  --covarCol PC{1:6},yob \
  --catCovarList sex,genotyping,batch,center \
  --bsize 1000 \
  --threads 16 \
  --out $STAGING/stage1_$ANS


# --qt = specifies quantitative trait
# --bed = PLINK binary files prefix for .bed/.bim/.fam files which contain the (directly) genotyped data
# --extract = List of SNPs that pass genotyping QC filters for this ancestry cluster (We generate this list prior to this step in PLINK, however if you have already performed sufficient QC on your genotype data file, you can omit this flag)
# --keep = List of participants that pass genotyping QC filters for this ancestry cluster (We generate this list prior to this step in PLINK, however if you have already performed sufficient QC on your genotype data file, you can omit this flag)
# --phenoFile = phenotype file path with the header FID IID pheno_col (Because we supply a list of QC'd participants for this ancestry using --keep, the phenotype file can contain the whole cohort and --keep flag will filter for this ancestry)
# --phenoCol = phenotype column name - not needed if only analysing one phenotype and phenoFile only contains three columns as above
# --covarFile = covariate file path with the header FiD IID C1 C2 C3 etc. (Again, can contain the whole cohort if filtering using either --keep or --remove flags)
# --catCovarList = list of categorical covariates in the covarFile
# --covarCol = numeric covariate column names - only needed if you have columns in covarFile you want to be ignored. Otherwise regenie uses all columns except the ones listed as categorical 
# --bsize = chunk size (base-pairs) for analysis
# --threads = for parallel processing with multiple cores - here we've set threads equal to number of cores requested for job
# --out = path to output file