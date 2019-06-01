## Setup

library(jsonlite)
library(purrr)
library(dplyr)
library(ggplot2)


durham = jsonlite::fromJSON(
  "https://api.darksky.net/forecast/24e13b35a014e3ca53a36a217243f61d/35.9940,-78.8986",
  simplifyDataFrame = FALSE
)

str(durham, max.level=1)

str(durham$minutely, max.level=1)
str(durham$minutely$data[[1]], max.level=1)

minutely = data_frame(
  time                 = map_int(durham$minutely$data, "time"),
  precipIntensity      = map_dbl(durham$minutely$data, "precipIntensity"),
  precipIntensityError = map_dbl(durham$minutely$data, "precipIntensityError"),
  precipProbability    = map_dbl(durham$minutely$data, "precipProbability"),
  precipType           = map_chr(durham$minutely$data, "precipType")
)

ggplot(minutely, aes(x=time, y=precipIntensity)) + geom_line()



str(durham$hourly$data[[1]], max.level=1)

## Generalization

map(durham$minutely$data, as_data_frame) %>% bind_rows()

data = list(
  currently = as_data_frame(durham$currently),
  minutely = map_dfr(durham$minutely$data, as_data_frame),
  hourly = map_dfr(durham$hourly$data, as_data_frame),
  daily = map_dfr(durham$daily$data, as_data_frame)
) %>% 
  map(
    function(tbl) {
      tbl %>% mutate_at(
        vars(contains("time")),
        as.POSIXct,
        tz = durham$timezone, origin = "1970-1-1"
      )
    }
  )


