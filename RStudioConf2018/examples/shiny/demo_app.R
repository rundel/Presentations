library(dplyr)
library(sf)
library(purrr)
library(shiny)
library(mapview)
library(leaflet)
  
pp = suppressWarnings(read_sf("data/nypp.shp")) %>%
  lwgeom::st_make_valid() %>%
  filter(Precinct < 35) %>%
  arrange(Precinct) %>%
  rename(precinct = Precinct) %>%
  st_transform(2831)


options(shiny.maxRequestSize=15*1024^2) 

shinyApp(
  ui = fluidPage(
    sidebarLayout(
      sidebarPanel = NULL,
      mainPanel = mainPanel(
        fluidRow(
          fileInput("file",'Upload prediction geojson')
        ),
        br(),
        fluidRow(
          h3(textOutput("text_score"))
        ),
        br(),
        fluidRow(
          splitLayout(
            cellWidths = c("50%", "50%"),
            leafletOutput("pred", width=300),
            leafletOutput("score", width=300)
          )
        )
      )
    )
  ),
  server = function(input, output, session) {

    pred = reactive({
      
      req(input$file)
      
      st_read(input$file$datapath, quiet = TRUE) %>%
        arrange(precinct) %>%
        st_transform(2831)
    })
    
    score = reactive({
      
      both = left_join(
        as.data.frame(pp),
        as.data.frame(pred()),
        by="precinct"
      )
      
      st_sf(
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
    })
    
    output$pred = renderLeaflet({
      mapview(pred(), col.regions = sf.colors(12,categorical=TRUE))@map
    })
    
    output$score = renderLeaflet({
      mapview(score(), col.regions = sf.colors(12,categorical=TRUE))@map
    })
    
    output$text_score = renderText({
      manh_area = sum(st_area(pp))
      pred_area = sum(st_area(pred()))
      
      score = round(pred_area / manh_area,4)
      attributes(score) = NULL
      
      paste('Score: ', score)
    })
  },
  options = list(width=600)
)
