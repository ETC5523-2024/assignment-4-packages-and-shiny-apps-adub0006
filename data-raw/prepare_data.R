## code to prepare `DATASET` dataset goes here

usethis::use_data(DATASET, overwrite = TRUE)


# Load necessary packages
library(tidyverse)

# Import the raw data from CSV file
raw_data <- read_csv("data-raw/data.csv")

# Data cleaning and preprocessing steps
cleaned_data <- raw_data %>%
  rename_all(tolower) %>%           # Convert column names to lowercase
  filter(!is.na(`transport emissions per kilometer travelled`))   # Remove rows with NA in the emissions column

# Save the cleaned data to the R package
usethis::use_data(cleaned_data, overwrite = TRUE)


