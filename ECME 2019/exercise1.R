library(dplyr)
library(nycflights13)

# 1. How many flights from New York (JFK) to Los Angeles (LAX) \
# did each carrier have in May?

flights %>%
  filter(origin == "JFK") %>%
  filter(dest == "LAX") %>%
  filter(month == 5) %>%
  group_by(carrier) %>%
  summarise(n =)

flights %>%
  filter(origin == "JFK") %>%
  filter(dest == "LAX") %>%
  filter(month == 5) %>%
  count(carrier)


flights %>%
  filter(origin == "JFK", dest == "LAX", month == 5) %>%
  count(carrier)

flights %>%
  filter(origin == "JFK", dest == "LAX", month == 5) %>%
  count(carrier)
