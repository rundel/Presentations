library(dplyr)
library(nycflights13)

# How many flights to Los Angeles (LAX) did each carrier
# have in May from JFK, and what was the average duration?

flights %>%
  filter(dest == "LAX", origin == "JFK") %>%
  filter(carrier %in% c("AA", "UA", "DL", "US")) %>%
  filter(month == 5) %>%
  group_by(carrier) %>%
  summarise(n = n(), avg_dur = mean(air_time, na.rm=TRUE))
