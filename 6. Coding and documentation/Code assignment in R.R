# Sets the path to the parent directory of RR classes
setwd("Z:\\File folders\\Teaching\\Reproducible Research\\2023\\Repository\\RRcourse2023\\6. Coding and documentation")

# Load required packages
library(readxl)
library(stringr)
library(dplyr)
library(Hmisc)

# Define constants
COUNTRIES <- c("Belgium", "Spain", "Poland")
NRCA_TASKS <- c("t_4A2a4", "t_4A2b2", "t_4A4a1")

# Function to standardize task variables
standardize_task <- function(data, task_var, country) {
  share_var <- paste0("share_", country)
  mean_val <- wtd.mean(data[[task_var]], data[[share_var]])
  sd_val <- sqrt(wtd.var(data[[task_var]], data[[share_var]]))
  (data[[task_var]] - mean_val) / sd_val
}

# Function to aggregate NRCA index
aggregate_nrca <- function(data, country) {
  std_nrca_var <- paste0("std_", country, "_NRCA")
  share_var <- paste0("share_", country)
  
  data[[paste0("multip_", country, "_NRCA")]] <- data[[std_nrca_var]] * data[[share_var]]
  
  aggregate(data[[paste0("multip_", country, "_NRCA")]], 
            by = list(data$TIME), 
            FUN = sum, na.rm = TRUE)
}

# 1. Load and prepare task data
task_data <- read.csv("Data\\onet_tasks.csv") %>%
  mutate(isco08_1dig = str_sub(isco08, 1, 1) %>% as.numeric())

aggdata <- task_data %>%
  group_by(isco08_1dig) %>%
  summarise(across(starts_with("t_"), mean, na.rm = TRUE)) %>%
  rename(ISCO = isco08_1dig)

# 2. Load and prepare employment data
isco_data <- lapply(1:9, function(i) {
  read_excel("Data\\Eurostat_employment_isco.xlsx", sheet = paste0("ISCO", i)) %>%
    mutate(ISCO = i)
})

all_data <- bind_rows(isco_data)

# 3. Calculate totals and shares
for (country in COUNTRIES) {
  # Calculate totals for each time period
  time_totals <- sapply(isco_data, function(df) df[[country]]) %>% 
    rowSums()
  
  # Assign to all_data
  all_data[[paste0("total_", country)]] <- rep(time_totals, times = 9)
  all_data[[paste0("share_", country)]] <- all_data[[country]] / all_data[[paste0("total_", country)]]
}

# 4. Combine data and calculate NRCA
combined <- all_data %>%
  left_join(aggdata, by = "ISCO") %>%
  # Standardize task variables
  mutate(across(all_of(NRCA_TASKS), 
                ~ standardize_task(cur_data(), cur_column(), "Belgium"),
                .names = "std_Belgium_{.col}")) %>%
  mutate(across(all_of(NRCA_TASKS), 
                ~ standardize_task(cur_data(), cur_column(), "Spain"),
                .names = "std_Spain_{.col}")) %>%
  mutate(across(all_of(NRCA_TASKS), 
                ~ standardize_task(cur_data(), cur_column(), "Poland"),
                .names = "std_Poland_{.col}"))

# Calculate NRCA indices
for (country in COUNTRIES) {
  std_cols <- paste0("std_", country, "_", NRCA_TASKS)
  combined[[paste0(country, "_NRCA")]] <- rowSums(combined[, std_cols])
  
  # Standardize NRCA
  share_var <- paste0("share_", country)
  mean_nrca <- wtd.mean(combined[[paste0(country, "_NRCA")]], combined[[share_var]])
  sd_nrca <- sqrt(wtd.var(combined[[paste0(country, "_NRCA")]], combined[[share_var]]))
  
  combined[[paste0("std_", country, "_NRCA")]] <- 
    (combined[[paste0(country, "_NRCA")]] - mean_nrca) / sd_nrca
}

# 5. Plot results
par(mfrow = c(length(COUNTRIES), 1))
for (country in COUNTRIES) {
  agg_result <- aggregate_nrca(combined, country)
  
  plot(agg_result$x, xaxt = "n", 
       main = paste("NRCA Index Over Time -", country),
       ylab = "NRCA Index", xlab = "Time", type = "l")
  axis(1, at = seq(1, nrow(agg_result), 3), 
       labels = agg_result$Group.1[seq(1, nrow(agg_result), 3)])
}
