

# Set sumstats location
sumstats_loc <- '/gpfs/igmmfs01/eddie/GenScotDepression/users/sam/Projects/dep_symp/Data/GWAS/UKB/Sumstats/'

# Set location for HWE test p-values - output by PLINK as .hardy files
hardy_loc <- '/gpfs/igmmfs01/eddie/GenScotDepression/users/sam/Projects/dep_symp/Data/Genotypes/UKB/whole_genome/'

# Set cohort name, scale, version
cohort <- "UKB"
scale <- "PHQ9"
vers <- "1"

# ancestry splits to use in loop - check these are correct
ancs <- c("EAS","AMR","SAS","MID","EUR","AFR")
i <- 3

# load packages
require(data.table)
require(dplyr)


# loop round each of the ancestries
for (i in 1:length(ancs)) {
  
  print(paste0("***Starting loop ",i," for ",ancs[i],"***"))
  
  ## read in regenie output file (which has -log10 pvalues)
  regenie <- fread(paste0(sumstats_loc, cohort, "_", scale, "_", ancs[i], "_v", vers, "_log10.regenie"))

  # Transform -LOG10P to P
  regenie$P <- 10^(regenie$LOG10P*-1)
  
  # keep/rename/reorder necessary columns for final sumstats file
  regenie_keep_col <- subset(regenie, select = c("CHROM", "GENPOS", "ID", "ALLELE1", "ALLELE0", "A1FREQ", "INFO", "BETA", "SE",      "CHISQ", "P", "N"))
  colnames(regenie_keep_col) <-                c("CHR",   "POS",    "ID", "A1",     "A2",       "A1FREQ", "INFO", "BETA", "BETA_SE", "STAT",  "P", "OBS_CT")
  
  
  ## Now join on the Hardy-Weinberg test p-value, calculated in plink with --hardy midp
  
  # Read in the HWE test pvalue data
  hardy <- fread(paste0(hardy_loc, "HWE_", ancs[i], ".hardy"))
  
  # Left join the HWE test pvalue data onto sumstats
  sumstats_to_send <- regenie_keep_col |>
                      left_join(hardy |> select(ID, MIDP), by = "ID") |>
                      rename(HWE = MIDP)
  
  ##finally output to gzipped tab delimited file
  # Define the output file path
  output_file <- paste0(sumstats_loc, cohort, "_", scale, "_", ancs[i], "_v", vers, ".txt.gz")
  
  # Write the data table to a tab-delimited gzipped file
  write.table(sumstats_to_send, 
              file = gzfile(output_file), 
              sep = "\t", 
              row.names = FALSE, 
              col.names = TRUE, 
              quote = FALSE)
  
}