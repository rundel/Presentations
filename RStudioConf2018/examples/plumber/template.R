scores_template = data.frame(
  team = character(), time = integer(), overall = double(),
  Precinct1=double(), Precinct5=double(), Precinct6=double(), 
  Precinct7=double(), Precinct9=double(), Precinct10=double(), 
  Precinct13=double(), Precinct14=double(), Precinct17=double(), 
  Precinct18=double(), Precinct19=double(), Precinct20=double(), 
  Precinct22=double(), Precinct23=double(), Precinct24=double(), 
  Precinct25=double(), Precinct26=double(), Precinct28=double(), 
  Precinct30=double(), Precinct32=double(), Precinct33=double(), 
  Precinct34=double()
) %>% mutate(time = as.POSIXct(time,origin="1970-1-1"))