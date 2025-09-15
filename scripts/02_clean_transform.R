# 02_clean_transform.R
library(tidyverse); library(lubridate); library(janitor); library(here)

all_trips_raw <- readRDS(here::here("output", "all_trips_raw.rds"))

# Detect start/end columns robustly
possible_start_cols <- c("started_at", "start_time", "start_time_local", "starttime")
possible_end_cols <- c("ended_at", "end_time", "end_time_local", "endtime")

colset <- names(all_trips_raw)

start_col <- intersect(possible_start_cols, colset) %>% first()
end_col   <- intersect(possible_end_cols, colset) %>% first()

# Attempt fallback patterns
if (is.null(start_col)) start_col <- grep("start", colset, value = TRUE)[1]
if (is.null(end_col)) end_col <- grep("end", colset, value = TRUE)[1]

# Convert to POSIXct with multiple attempted formats
parse_any_datetime <- function(x) {
  parse_date_time(x, orders = c("ymd HMS", "mdy HMS", "ymd HM", "mdy HM","Y-m-d H:M:S","dmy HMS"), tz = "UTC")
}

all_trips <- all_trips_raw %>%
  mutate(
    started_at = parse_any_datetime(.data[[start_col]]),
    ended_at   = parse_any_datetime(.data[[end_col]]),
    ride_length_min = as.numeric(difftime(ended_at, started_at, units = "mins"))
  ) %>%
  mutate(
    day_of_week = wday(started_at, label = TRUE, abbr = FALSE),
    month = month(started_at, label = TRUE, abbr = FALSE),
    year = year(started_at)
  )

# Remove negative and zero-length rides, but save them for audit
invalid_rides <- all_trips %>% filter(is.na(ride_length_min) | ride_length_min <= 0)
valid_rides   <- all_trips %>% filter(!is.na(ride_length_min) & ride_length_min > 0)

saveRDS(list(valid = valid_rides, invalid = invalid_rides), file = here::here("output", "trips_cleaned.rds"))
