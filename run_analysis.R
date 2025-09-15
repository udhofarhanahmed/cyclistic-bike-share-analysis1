# run_analysis.R
# This script executes the complete Cyclistic data analysis pipeline.
# It sources the load, clean, and analysis scripts in order, then renders the final R Markdown report.
#
# Usage: Open R/RStudio, set the working directory to the project root, and run:
# source("run_analysis.R")

# --- 1. Load Required Libraries ---
if (!requireNamespace("pacman", quietly = TRUE)) install.packages("pacman")
pacman::p_load(tidyverse, lubridate, janitor, skimr, renv, here, fs, readr, rmarkdown, knitr, gt, plotly, scales)

# --- 2. Data Ingestion & Merging ---
message("Step 1 of 3: Loading and merging raw data...")
source(here::here("scripts", "01_load_and_merge.R"))
message("Data merging complete. Raw data saved to output/all_trips_raw.rds")

# --- 3. Data Cleaning & Transformation ---
message("Step 2 of 3: Cleaning and transforming the data...")
source(here::here("scripts", "02_clean_transform.R"))
message("Data cleaning complete. Cleaned data saved to output/trips_cleaned.rds")

# --- 4. Analysis and Plot Generation ---
message("Step 3 of 3: Performing analysis and generating plots...")
source(here::here("scripts", "03_analysis_plots.R"))
message("Analysis complete. Figures and tables saved to the output folder.")

# --- 5. Render the R Markdown Report ---
message("Rendering the final R Markdown report...")

# --- NEW: Create the output folder if it doesn't exist ---
if (!dir.exists(here::here("output", "reports"))) {
  dir.create(here::here("output", "reports"), recursive = TRUE)
}

rmarkdown::render(here::here("reports", "cyclistic_analysis.Rmd"),
                  output_file = here::here("output", "reports", "cyclistic_analysis.html"))

message("Analysis pipeline complete.")
message("The final report is located at: output/reports/cyclistic_analysis.html")
