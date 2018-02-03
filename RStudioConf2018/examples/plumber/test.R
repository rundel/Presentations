library(httr)

for(i in 1:10) {
  
  x = suppressWarnings(
    st_read("data/precincts.json", quiet = TRUE) %>% st_buffer(0.001 + (i-1)/1000)
  )
  
  st_write(x,"data/precincts2.geojson", quiet=TRUE, delete_dsn=TRUE)
  file = base64enc::base64encode("data/precincts2.geojson")
  
  body = list(
    team="Team00", 
    key="0000000000000000",
    file=file
  )
  POST("http://127.0.0.1:7887/prediction", body=body, encode = "json") 
  
  Sys.sleep(2)
}  
