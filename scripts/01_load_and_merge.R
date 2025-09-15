# 01_load_and_merge.R
library(tidyverse); library(janitor); library(here); library(fs)

data_root <- here::here("data")

# Recursively find all csv files
csv_files <- dir_ls(data_root, recurse = TRUE, regexp = "\\.csv$")

# Generic reader that tolerates different schemas and returns a tibble with cleaned names
safe_read <- function(path) {
  tryCatch({
    read_csv(path, show_col_types = FALSE) %>%
      clean_names() %>%
      mutate(source_file = path)
  }, error = function(e) {
    message("Failed to read: ", path, " -> ", e$message)
    tibble()
  })
}

all_trips_raw <- map_dfr(csv_files, safe_read)
saveRDS(all_trips_raw, file = here::here("output", "all_trips_raw.rds"))
