# 03_analysis_plots.R
library(tidyverse); library(here); library(scales); library(gt); library(plotly)

data <- readRDS(here::here("output", "trips_cleaned.rds"))$valid

user_col_candidates <- c("member_casual","user_type","usertype","member_type")
user_col <- intersect(user_col_candidates, names(data)) %>% first()
if (is.null(user_col)) {
  data$member_casual <- "unknown"
  user_col <- "member_casual"
}

# Summaries
by_type <- data %>%
  group_by(.data[[user_col]]) %>%
  summarise(n = n(), avg_min = mean(ride_length_min), median_min = median(ride_length_min)) %>%
  arrange(desc(n))

# Save gt table
gt_tbl <- by_type %>% gt::gt()
gtsave <- function(gtobj, path) { html <- as_raw_html(gtobj); writeLines(html, path) }
gtsave(gt_tbl, here::here("output", "tables", "summary_by_type.html"))

# Plot: rides by weekday
rides_day <- data %>%
  group_by(.data[[user_col]], day_of_week) %>%
  summarise(number_of_rides = n(), avg_ride_length = mean(ride_length_min)) %>%
  ungroup()

p1 <- ggplot(rides_day, aes(x = factor(day_of_week, levels=c("Sunday","Monday","Tuesday","Wednesday","Thursday","Friday","Saturday")),
                             y = number_of_rides,
                             fill = .data[[user_col]])) +
  geom_col(position = "dodge") +
  scale_y_continuous(labels = label_comma()) +
  labs(title = "Number of Rides by Weekday & User Type", x = "Weekday", y = "Rides") +
  theme_minimal(base_size = 14)

ggsave(here::here("output", "figures", "rides_by_weekday.png"), p1, width = 12, height = 6)

# Interactive version
p1_plotly <- plotly::ggplotly(p1)
htmlwidgets::saveWidget(p1_plotly, file = here::here("output", "figures", "rides_by_weekday_interactive.html"))

# Additional plots: heatmap (hour vs weekday) — helpful to show peak usage
data_hour <- data %>%
  mutate(hour = hour(started_at)) %>%
  group_by(hour, day_of_week, .data[[user_col]]) %>%
  summarise(rides = n()) %>%
  ungroup()

p_heat <- ggplot(data_hour, aes(x = hour, y = day_of_week, fill = rides)) +
  geom_tile() +
  labs(title = "Rides heatmap (hour vs weekday)", x = "Hour of day", y = "Weekday") +
  theme_minimal()

ggsave(here::here("output", "figures", "heatmap_hour_weekday.png"), p_heat, width = 10, height = 6)
