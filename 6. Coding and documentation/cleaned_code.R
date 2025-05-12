########## Load Libraries & Set Working Directory##############

# Load necessary libraries
library(readxl)   
library(dplyr)
library(stringr)
library(Hmisc)

# Set working directory
setwd("Z:\\File folders\\Teaching\\Reproducible Research\\2023\\Repository\\RRcourse2023\\6. Coding and documentation")


######### Load Data Efficiently (Using Loops)##################

# Load task data
task_data <- read.csv("Data/onet_tasks.csv")

# Read employment data from Excel for all ISCO levels (1-9)
isco_data <- lapply(1:9, function(i) {
  df <- read_excel("Data/Eurostat_employment_isco.xlsx", sheet = paste0("ISCO", i))
  df$ISCO <- i  # Add ISCO category
  return(df)
})

# Combine all ISCO data into one dataframe
all_data <- bind_rows(isco_data)

############# Automate Total Worker Calculation #######################

# List of countries
countries <- c("Belgium", "Spain", "Poland")

# Calculate total workers for each country
total_workers <- lapply(countries, function(country) {
  rowSums(sapply(isco_data, function(df) df[[country]]))
})

# Store totals in a named list
names(total_workers) <- countries

# Add total workers data to all_data
for (country in countries) {
  all_data[[paste0("total_", country)]] <- rep(total_workers[[country]], each = 9)
  all_data[[paste0("share_", country)]] <- all_data[[country]] / all_data[[paste0("total_", country)]]
}

# List of countries
countries <- c("Belgium", "Spain", "Poland")

# Calculate total workers for each country
total_workers <- lapply(countries, function(country) {
  rowSums(sapply(isco_data, function(df) df[[country]]))
})

# Store totals in a named list
names(total_workers) <- countries

# Add total workers data to all_data
for (country in countries) {
  all_data[[paste0("total_", country)]] <- rep(total_workers[[country]], each = 9)
  all_data[[paste0("share_", country)]] <- all_data[[country]] / all_data[[paste0("total_", country)]]
}

############# Process Task Data#############################

# Extract first digit of ISCO-08 code
task_data$isco08_1dig <- as.numeric(str_sub(task_data$isco08, 1, 1))

# Aggregate task data by ISCO category
aggdata <- task_data %>%
  group_by(isco08_1dig) %>%
  summarise(across(starts_with("t_"), mean, na.rm = TRUE))

# Merge task data with employment data
combined <- left_join(all_data, aggdata, by = c("ISCO" = "isco08_1dig"))

############# Standardization Function #######################


standardize_task <- function(task, country) {
  mean_val <- wtd.mean(combined[[task]], combined[[paste0("share_", country)]])
  sd_val <- sqrt(wtd.var(combined[[task]], combined[[paste0("share_", country)]]))
  return((combined[[task]] - mean_val) / sd_val)
}

# Define the tasks of interest
tasks_of_interest <- c("t_4A2a4", "t_4A2b2", "t_4A4a1")

# Standardize each task for each country
for (task in tasks_of_interest) {
  for (country in countries) {
    combined[[paste0("std_", country, "_", task)]] <- standardize_task(task, country)
  }
}


########  Compute Task Content Intensity & Country-Level Mean  ##########

# Compute Non-Routine Cognitive Analytical (NRCA) Index
for (country in countries) {
  combined[[paste0(country, "_NRCA")]] <- rowSums(combined[paste0("std_", country, "_", tasks_of_interest)])
  
  # Standardize NRCA index
  mean_val <- wtd.mean(combined[[paste0(country, "_NRCA")]], combined[[paste0("share_", country)]])
  sd_val <- sqrt(wtd.var(combined[[paste0(country, "_NRCA")]], combined[[paste0("share_", country)]]))
  combined[[paste0("std_", country, "_NRCA")]] <- (combined[[paste0(country, "_NRCA")]] - mean_val) / sd_val
}


############# Compute Time Series Data #######################

# Compute weighted mean of NRCA over time
agg_NRCA <- lapply(countries, function(country) {
  aggregate(combined[[paste0("std_", country, "_NRCA")]] * combined[[paste0("share_", country)]],
            by = list(combined$TIME), FUN = sum, na.rm = TRUE)
})


############# Plot the Data #######################

# Assign country names
names(agg_NRCA) <- countries

for (country in countries) {
    plot(agg_NRCA[[country]]$x, 
       xaxt = "n", 
       main = paste(country, "NRCA Trend"), 
       type = "l", 
       ylab = country)  # Set y-axis label to country name
  
  axis(1, 
       at = seq(1, 40, 3), 
       labels = agg_NRCA[[country]]$Group.1[seq(1, 40, 3)])
}

