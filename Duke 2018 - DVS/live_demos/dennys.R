## Setup

library(rvest)
library(dplyr)
library(purrr)
library(stringr)

## Restaraunt level data

url = "https://locations.dennys.com/NC/DURHAM/248848"

get_restaraunt_data = function(url) {
  page = read_html(url)
  
  data_frame(
    name = page %>% html_nodes("#location-name") %>% html_text(),
    address = page %>% html_nodes(".c-address-street-1") %>% html_text(),
    city = page %>% html_nodes(".c-address-city span") %>% html_text(),
    state = page %>% html_nodes(".c-address-state") %>% html_text(),
    zipcode = page %>% html_nodes(".c-address-postal-code") %>% html_text(),
    telephone = page %>% html_nodes("#telephone") %>% html_text()
  ) 
}

get_restaraunt_data("https://locations.dennys.com/NC/DURHAM/248848")
get_restaraunt_data("https://locations.dennys.com/NC/BATTLEBORO/246171")


## State level data

get_city_links = function(url) {
  page = read_html(url)
  
  page %>% html_nodes(".c-location-grid-item-title a") %>% 
    html_attr("href") %>% file.path(dirname(url), .)
}

get_state_data = function(url) {
  
  page = read_html(url)
  
  base_url = dirname(url)
  
  state_links = page %>% html_nodes(".c-directory-list-content-item-link") %>% 
    html_attr("href") %>% file.path(base_url, .)
  
  rest_links = state_links[str_detect(state_links, "[0-9]{4,}$")]
  
  city_links = state_links[!str_detect(state_links, "[0-9]{4,}$")] %>%
    lapply(get_city_links) %>%
    unlist()
  
  
  lapply(
    c(rest_links, city_links), 
    function(link) {
      print(link)
      get_restaraunt_data(link)
    }
  ) %>%
    bind_rows()
}


get_state_data("https://locations.dennys.com/NC")
