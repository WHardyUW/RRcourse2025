
install.packages("readxl")    
library(readxl)


data_path <- "~/Desktop/Metaanalysis/metaanalysis_data.xlsx"


meta_data <- read_excel(data_path)


head(meta_data)

install.packages("meta")     
library(meta)


boys_meta <- metamean(
  n = N_boys,
  mean = Mean_boys_play_male,
  sd = SD_boys_play_male,
  data = meta_data,
  studlab = Study,
  comb.fixed = TRUE,
  comb.random = TRUE,
  method.tau = "REML"
)


summary(boys_meta)

# Basic funnel plot
funnel(boys_meta)

# This funnel plot visualizes the relationship between 
# study size (Standard Error) and the mean time boys spent 
# playing with male-typed toys. In a well-balanced meta-analysis 
# without publication bias, the studies should be symmetrically 
# distributed around the overall mean. 
# 
# In this case, the plot shows some asymmetry — smaller studies 
# (with higher standard errors) are missing on the left-hand side, 
# which may suggest the presence of publication bias or selective 
# reporting of significant results.


# Meta-regression to test method and quality effects
metareg(boys_meta, ~ Setting + `Parent present` + `NOS score`)


colnames(meta_data)

metareg(boys_meta, ~ `Female authors`)

# --- Assignment Answers ---------------------------------------------------

# a) Combine the effects:
# We combined effect sizes using metamean(). The random-effects model estimated
# the average male toy-play time at ~183 seconds (with high heterogeneity: I² = 97.5%).

# b) Funnel plot:
# The funnel plot shows some asymmetry. Smaller studies reporting low toy-play time
# are underrepresented, suggesting possible publication bias.

# c) Method / Quality effects:
# Meta-regression showed no significant effects of setting, parent presence,
# or NOS score on results. NOS score had a borderline effect (p ≈ 0.098).

# d) Author gender:
# The number of female authors significantly predicted lower male toy-play time (p = 0.035).
# Suggests potential reporting or framing differences based on researcher gender.

# --------------------------------------------------------------------------

