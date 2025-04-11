

# NOTE: Cols and sumstats file names may need renaming in the code, depending how sumstats were generated (required columns: CHROM, POS, P)

# load packages
require(data.table)
library(topr)
library(ggrepel)
library(dplyr)


# Set cohort name, scale, version
cohort <- "UKB"
scale <- "PHQ9"
vers <- "1"

# ancestry splits to use in loop - check these are correct
ancs <- c("EAS","AMR","SAS","MID","EUR","AFR")

# Set sumstats location
sumstats_loc <- '/gpfs/igmmfs01/eddie/GenScotDepression/users/sam/Projects/dep_symp/Data/GWAS/UKB/Sumstats'
# Set plots location
plots_loc <- '/gpfs/igmmfs01/eddie/GenScotDepression/users/sam/Projects/dep_symp/Data/GWAS/UKB/Plots'





## Plot Manhattan - loop round each of the ancestries
for (i in 1:length(ancs)) {
  
  print(paste0("***Starting Manhattan loop ",i," for ",ancs[i],"***"))

  # Set working directory to sumstats location
  setwd(sumstats_loc)


  sumstats <- fread(paste0(cohort, "_", scale, "_", ancs[i], "_v", vers, ".txt.gz"), header = TRUE)
 

 
  # Set working directory to plots location
  setwd(plots_loc)

  tiff(paste0(cohort, "_", scale, "_", ancs[i], "_v", vers, "_manhattan.tiff"), width = 10, height = 6, units = "in", res = 300)

  manhattan(df = sumstats,
            legend_labels = "",
            sign_thresh = 5e-08,
            sign_thresh_color = "black",
            sign_thresh_label_size = 0,
	    ymax = 20, ymin = 3, scale = 0.8,
            title = paste0(cohort, " (", ancs[i], ")"))

  dev.off()
}

## Plot QQ - loop round each of the ancestries
for (i in 1:length(ancs)) {
  
  print(paste0("***Starting QQ loop ",i," for ",ancs[i],"***"))

  # Set working directory to sumstats location
  setwd(sumstats_loc)

  sumstats <- fread(paste0(cohort, "_", scale, "_", ancs[i], "_v", vers, ".txt.gz"), header = TRUE)

  # Set working directory to plots location
  setwd(plots_loc)
  
  tiff(paste0(cohort, "_", scale, "_", ancs[i], "_v", vers, "_qq.tiff"), width = 6, height = 6, units = "in", res = 300)

  qqtopr(sumstats, title = paste0(cohort, " (", ancs[i], ")"))

  dev.off()

}

###############################################################################
