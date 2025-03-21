
## Short R script showing example of Depression score phenotype creation with two occasions of PH9 scores in UKB
# We are using data from more than two occasions in UKB, but this code shows for the more simple case of just two 

# Bring together the 9 questionnare responses for each occasion (in this case from UKB's mental health and pain questionnaires)
dep_scores_ukb_df <- 
  full_join(MentalHealth, ExperienceOfPain, by='f.eid') |>
  select(f.eid,
         # PHQ-9 Mental Health Questionnaire      
         f.20510.0.0,
         f.20514.0.0,
         f.20517.0.0,
         f.20519.0.0,
         f.20511.0.0,
         f.20507.0.0,
         f.20508.0.0,
         f.20518.0.0,
         f.20513.0.0,
         # PHQ-9 Pain Questionnaire  
         f.120105.0.0,
         f.120104.0.0,
         f.120106.0.0,
         f.120107.0.0,
         f.120108.0.0,
         f.120109.0.0,
         f.120110.0.0,
         f.120111.0.0,
         f.120112.0.0,
         
         f.20400.0.0, #date completed MHQ
         f.120128.0.0 #date completed Pain
  ) |>
  
  # recode all of the response columns to a numerical value
  mutate(across(c(2:19),
                ~ case_when(. == "Not at all" ~ 0,
                            . == "Several days" ~ 1,
                            . == "More than half the days" ~ 2,
                            . == "Nearly every day" ~ 3,
                            TRUE ~ NA))) |>
  # Count total scores for the two occasions - if any of the questions are NA, prefer not to answer, or don't know then PHQ2/9 will be NA
  mutate(PHQ9_mhq = f.20510.0.0 +
           f.20514.0.0 +
           f.20517.0.0 +
           f.20519.0.0 +
           f.20511.0.0 +
           f.20507.0.0 +
           f.20508.0.0 +
           f.20518.0.0 +
           f.20513.0.0,
         PHQ9_pain = f.120105.0.0 +
           f.120104.0.0 +
           f.120106.0.0 +
           f.120107.0.0 +
           f.120108.0.0 +
           f.120109.0.0 +
           f.120110.0.0 +
           f.120111.0.0 +
           f.120112.0.0)  |>
  
  # Take the mean score per individual (of non-missing instances)
  mutate(dep_score_mean = rowMeans(pick(PHQ9_mhq, PHQ9_pain), na.rm = TRUE)) |>
           
  # Standardise the mean score using the scale function
  mutate(dep_score_stand_mean = scale(dep_score_mean)) 

