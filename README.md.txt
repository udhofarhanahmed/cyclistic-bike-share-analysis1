Cyclistic Bike-share Analysis
Author: Farhan Ahmed

Purpose: An in-depth exploratory data analysis comparing casual riders and members of Cyclistic's bike-share program. This project is part of the Google Professional Data Analytics portfolio.

Project Overview
This project analyzes 12 months of Cyclistic's trip data to identify key trends, differences between rider types, and actionable insights. The analysis pipeline is built for reproducibility using R and the renv package.

Project Structure
data/: This folder is intended to hold the raw CSV files for the analysis. It is .gitignore'd to prevent large files from being committed to the repository.

scripts/: Contains the modular R scripts that form the data pipeline.

01_load_and_merge.R: Ingests all CSVs, handles potential schema inconsistencies, and merges them into a single dataset.

02_clean_transform.R: Cleans the merged data, parses datetime columns, and filters out invalid rides.

03_analysis_plots.R: Performs the main exploratory analysis, generates figures and summary tables.

reports/: Contains the source R Markdown (.Rmd) file for the final report.

output/: Stores the intermediate and final outputs, including cleaned data (.rds), figures, tables, and the final HTML report.

How to Run the Analysis
Clone the repository:

git clone [https://github.com/your-username/cyclistic-analysis.git](https://github.com/your-username/cyclistic-analysis.git)
cd cyclistic-analysis

Place data: Put your raw monthly CSV folders (e.g., 202301-divvy-tripdata/) inside the data/ folder.

Initialize R environment: Open RStudio within the project folder and run renv::restore() in the console. This will install all required R packages to the correct versions.

Run the analysis pipeline: Run the single, packaged script.

source("run_analysis.R")

View the report: The final report, cyclistic_analysis.html, will be generated in the output/reports/ folder.

Key Findings
Rider Behavior: Casual riders typically take longer rides and are more active on weekends. Members, by contrast, use the bikes more frequently for shorter commutes during the work week.

Usage Patterns: The busiest days for members are Tuesdays and Wednesdays, while for casual riders it's Saturdays and Sundays.

Ride Duration: The median ride length for casual riders is significantly longer than for members, confirming a different usage pattern.

License
This project is licensed under the MIT License.

Contact
For any questions or feedback, please contact me at: your-email@example.com