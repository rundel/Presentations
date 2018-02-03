suppressPackageStartupMessages(library(plumber))
suppressPackageStartupMessages(library(dplyr))
suppressPackageStartupMessages(library(pool))
suppressPackageStartupMessages(library(sf))
suppressPackageStartupMessages(library(jsonlite))
suppressPackageStartupMessages(library(purrr))
suppressPackageStartupMessages(library(glue))
suppressPackageStartupMessages(library(ggplot2))


source("utility.R")

keys = read.csv("dbs/keys.csv",stringsAsFactors = FALSE)
keys = setNames(keys$key, keys$team)

pool = dbPool(
  drv = RSQLite::SQLite(),
  dbname = "dbs/scores.sqlite"
)

source("template.R")
if (!db_has_table(pool, "scores"))
  copy_to(pool, scores_template,"scores",
          temporary = FALSE, overwrite = FALSE)

# Using EPSG:2831 for m units
precincts = suppressWarnings(st_read("data/nypp.shp", quiet = TRUE)) %>% 
  select(precinct = Precinct) %>% 
  filter(precinct <= 34) %>% 
  st_transform(2831)
precinct_area = st_area(precincts)


pr = plumber::plumb("scoring_api.R")

pr$registerHook(
  "exit", 
  function(){
    poolClose(pool)
  }
)

pr$run(port=7887,swagger=TRUE)