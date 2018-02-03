markdown_output = function(df) {
  df %>%
    knitr::kable() %>%
    as.character() %>%
    paste(collapse="\n") %>%
    paste0("\n", ., "\n\n")
}

#' @get /scoreboard
#' @html
function() {
  pool %>% 
    tbl("scores") %>% 
    select(team, overall) %>%
    collect() %>%
    group_by(team) %>% 
    arrange(overall) %>% 
    slice(1) %>% 
    mutate(overall = round(overall,5)) %>%
    ungroup() %>%
    arrange(overall) %>%
    markdown_output()
}

#' @get /score
#' @html
function(t) {
  if (missing(t))
    "Error - No team specified\n"
  else 
    pool %>% 
    tbl("scores") %>% 
    filter(team == t) %>% 
    arrange(desc(time)) %>%
    head(1) %>%
    collect() %>%
    tidyr::gather(region, score, -team, -time) %>%
    select(-time, -team) %>%
    mutate(score = formatC(score, digits=4, format="fg")) %>%
    markdown_output()
}

#' @get /history
#' @html
function(t) {
  if (missing(t))
    "Error - No team specified\n"
  else 
    pool %>% 
      tbl("scores") %>% 
      filter(team == t) %>% 
      arrange(desc(time)) %>%
      head(10) %>%
      select(team, time, overall) %>%
      collect() %>%
      mutate(time = as.POSIXct(time, origin="1970-1-1")) %>%
      mutate(overall = formatC(overall, digits=4, format="fg")) %>%
      markdown_output()
}



#' 
#' @post /prediction
function(req, res){
  body = fromJSON(req$postBody)
  
  if (keys[body$team] != body$key) {
    res$status = 403
    res$body = paste0("Invalid key for ", body$team)
    res$setHeader("Content-Type","text/html;")
    
    return(res)
  }
  
  pred_json = base64enc::base64decode(body$file) %>% 
    rawToChar() %>% 
    st_read(quiet = TRUE) %>%
    st_transform(st_crs(precincts)) %>%
    setNames(., tolower(names(.))) %>%
    mutate(precinct = as.integer(precinct))
  
  both = left_join(
    as.data.frame(precincts),
    as.data.frame(pred_json),
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
    st_set_crs(st_crs(precincts))

  pred_area = st_area(res)
  
  by_precinct =  strip_attrs(pred_area / precinct_area)
  overall = strip_attrs(sum(pred_area) / sum(precinct_area))
  
  cols = names(scores_template)
  vals = c(body$team, as.double(Sys.time()), overall, by_precinct)
  
  
  
  sql = glue_sql("INSERT INTO scores VALUES ({vals*})", .con = pool)
  
  conn = poolCheckout(pool)
  dbBegin(conn)
  dbExecute(conn, sql)
  dbCommit(conn)
  poolReturn(conn)
  
  overall
}

#' Log some information about the incoming request
#' @filter logger
function(req) {
  cat(as.character(Sys.time()), " - ", 
      req$REQUEST_METHOD, " ", 
      req$PATH_INFO, req$QUERY_STRING, 
      " - ", req$REMOTE_ADDR, "\n", sep="")
  plumber::forward()
}
