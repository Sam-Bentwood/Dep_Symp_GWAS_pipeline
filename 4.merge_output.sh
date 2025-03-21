#!/bin/bash

# Specify the directory containing the regenie output files
STAGING=/gpfs/igmmfs01/eddie/GenScotDepression/users/sam/Projects/dep_symp/Data/GWAS/UKB/REGENIE_staging

# Specify the directory for final sumstats output files
OUTPUT=/gpfs/igmmfs01/eddie/GenScotDepression/users/sam/Projects/dep_symp/Data/GWAS/UKB/Sumstats

# Your cohort name
COHORT=UKB

# Scale used
SCALE=PHQ9

# Ancestry
ANS=SAS

# Version
VERS=1

# Build output file name
MERGED_OUTPUT_LOG10=$OUTPUT/${COHORT}_${SCALE}_${ANS}_v${VERS}_log10.regenie

# Remove any existing merged output file
rm -f $MERGED_OUTPUT_LOG10

# Loop through the output files and concatenate them
for file in $STAGING/stage2_${ANS}_chr*.regenie; do
    # Skip the header in all files except the first one
    if [ ! -f $MERGED_OUTPUT_LOG10 ]; then
        cat "$file" >> "$MERGED_OUTPUT_LOG10"
    else
        tail -n +2 "$file" >> "$MERGED_OUTPUT_LOG10"
    fi
done

# After merging please:
#  Convert -log10P values to raw P and keep/rename required columns (5.final_sumstats_format.R)

###############################################################################