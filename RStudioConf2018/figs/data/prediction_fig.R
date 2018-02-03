library(dplyr)
library(sf)
library(purrr)
  
pp = fs::path(here::here(),"figs/data/nypp.shp") %>%
  read_sf() %>%
  lwgeom::st_make_valid() %>%
  filter(Precinct < 35) %>%
  arrange(Precinct) %>%
  rename(precinct = Precinct) %>%
  st_transform(2831)


pred = fs::path(here::here(),"figs/data/predict.geojson") %>%
  st_read() %>%
  arrange(precinct) %>%
  st_transform(2831)

both = left_join(
  as.data.frame(pp),
  as.data.frame(pred),
  by="precinct"
)

res = st_sf(
  precinct = both$precinct, 
  map2(
    both$geometry.x, 
    both$geometry.y, 
    function(x,y) {
      if (!is.null(y))
        st_sym_difference(x,y)
      else
        x
    }
  ) %>% st_sfc()
) %>% 
  st_set_crs(st_crs(pp))

png(fs::path(here::here(), "figs","prediction.png"), width=1200, height=600, res = 120)
par(mfrow=c(1,3), mar=c(5,3,5,3))
plot(st_geometry(pred), col = sf.colors(12, categorical = TRUE), border=NA, main="Prediction"); box()
plot(st_geometry(pp), col = sf.colors(12, categorical = TRUE), border=NA, main="Precincts"); box()
plot(st_geometry(res), col = sf.colors(12, categorical = TRUE), border=NA, main="Score"); box()
dev.off()