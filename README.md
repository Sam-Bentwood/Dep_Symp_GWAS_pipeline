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

`--bed`: **PLINK** binary files prefix for .bed/.bim/.fam files

`--extract`: = List of SNPs that pass QC filter (We generate this list in **PLINK**, however if you have already performed sufficient QC on your genotyped data file, you can omit this flag)

`--phenoFile`: Path to your phenotype file with the header `FID IID pheno_col`

`--phenoCol`: Phenotype column name

`--covarFile`: Covariate file path with the header `FID IID C1 C2 C3`

`--covarCol`: Covariate column names

`--bsize`: Chunk size for analysis

`--bt`: Option for binary trait

`--out`: Path to output file


### Step 2 
`--bgen`: Path to imputed data. Here we use the .bgen format split by chromosome. See REGENIE documentation for more info on file input

`--phenoFile`: Path to your phenotype file with the header `FID IID pheno_col`

`--phenoCol`: Phenotype column name

`--sample`: Sample file corresponding to input bgen (can also use `--keep` / `--remove` flags to only include individuals that pass QC filtering, see REGENIE documentation)

`--covarFile`: Covariate file path with the header `FID IID C1 C2 C3`

`--covarCol`: Covariate column names

`--bsize`: Chunk size for analysis

`--minMAC`: Minimum minor allele count

`--minINFO`: Minimum imputation info score

`--bt`: Option for binary trait

`--af-cc` : To output A1FREQ in case/controls separately in the step 2 result file and N_CASES N_CONTROLS

`--firth` `--approx`: Firth LRT, computational speed up

`--pThresh`: P-value threshold to apply firth correction

`--pred`: Path to file containing predictions from **STEP 1**

`--out`: Path to output file(s)
