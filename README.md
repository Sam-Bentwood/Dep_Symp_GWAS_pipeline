# Depressive Symptoms GWAS

A repository with example shell scripts for running the GWAS pipeline using REGENIE. Included are also some R scripts with example code for creating the depression score phenotype, creating the final desired sumstats file format and producing Manhattan and QQ plots

## Instructions

* Install REGENIE if not already installed. The scripts assume install via Conda but other install options are available: https://rgcgithub.github.io/regenie/install/.
* To use example scripts as templates:
  + Clone this GitHub repository, edit scripts and set up as appropriate
```
git clone git@github.com:Sam-Bentwood/Dep_Symp_GWAS_pipeline.git
```
* Step `1.depression_score_pheno.R` provides example code for creating the depression score phenotype.
* Steps `2.regenie_step1.sh`, `3.regenie_step2.sh` and `4.merge_output.sh` are the core scripts for running REGENIE and merging chromosome results together.
* If you already have a pipeline set-up or don't need templates, please still refer to our examples to make sure flags/thresholds etc. correspond.
* After running association testing, please make sure you produce the final sumstats file in the required format, including converting -log10P values to raw P values (see script `5.final_sumstats_format.R`).
* Generate Manhattan and QQ plots using the `6.plot_results.R` script provided.
* Return back to the SOP document for how to upload and report your results.

## Contact

For any questions or uncertainties please contact Sam Bentwood at sam.bentwood@ed.ac.uk 

## REGENIE flag options

These are also included in the shell scripts provided

### Step 1

`--qt` = setting to quantitative trait

`--bed` = PLINK binary files prefix for .bed/.bim/.fam files which contain the (directly) genotyped data

`--extract` = List of SNPs that pass genotyping QC filters for this ancestry cluster (We generate this list prior to this step in PLINK, however if you have already performed sufficient QC on your genotype data file, you can omit this flag)

`--keep` = List of participants that pass genotyping QC filters for this ancestry cluster (We generate this list prior to this step in PLINK, however if you have already performed sufficient QC on your genotype data file, you can omit this flag)

`--phenoFile` = phenotype file path with the header FID IID pheno_col (Because we supply a list of QC'd participants for this ancestry using --keep, the phenotype file can contain the whole cohort and --keep flag will filter for this ancestry)

`--phenoCol` = phenotype column name - not needed if only analysing one phenotype and phenoFile only contains three columns as above

`--covarFile` = covariate file path with the header FiD IID C1 C2 C3 etc. (Again, can contain the whole cohort if filtering using either --keep or --remove flags)

`--catCovarList` = list of categorical covariates in the covarFile

`--covarCol` = numeric covariate column names - only needed if you have columns in covarFile you want to be ignored. Otherwise regenie uses all columns except the ones listed as categorical 

`--bsize` = chunk size (base-pairs) for analysis

`--threads` = for parallel processing with multiple cores - here we've set threads equal to number of cores requested for job

`--out` = path to output file


### Step 2 

`--pgen` = path to imputed data. Here we use the .pgen format, so use the pgen flag and point to file prefix for .pgen/.psam/.pvar files. See REGENIE documention for more info on file input

`--chr` = chromosome number - if you have bgen files split by chromosome then you will omit this flag and chromosome number will be specified in the path in --bgen flag

`--phenoFile` = path to your phenotype file with the header FID IID pheno_col 

`--phenoCol` = phenotype column name - not needed if only analysing one phenotype and phenoFile only contains three columns as above

`--covarFile` = covariate file path with the header FiD IID C1 C2 C3 etc

`--catCovarList` = list of categorical covariates in the covarFile

`--covarCol` = numeric covariate column names - only needed if you have columns in covarFile you want to be ignored. Otherwise regenie uses all columns except the ones listed as categorical 

`--bsize` = chunk size for analysis

`--minMAC` = minimum minor allele count

`--minINFO` = minimum imputation info score

`--qt` = specifies quantitative trait

`--pred` = path to file containing predictions from STEP 1

`--out` = path to output file(s)

`--threads` = for parallel processing with multiple cores - here we've set threads equal to number of cores requested for job
