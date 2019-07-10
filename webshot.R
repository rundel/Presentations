library(magrittr)

args = commandArgs(trailingOnly = TRUE)

input = args[[1]]
input = stringr::str_replace(input, "Rmd$", "html")

if (length(args) == 1) {
  output = stringr::str_replace(input, "html$", "pdf")
} else {
  output = args[[2]]
}

if (!stringr::str_detect(output,"pdf$"))
  dir.create(output, recursive = TRUE, showWarnings = FALSE)


if (fs::is_dir(output)) {
  output = fs::path_file(input) %>% 
    stringr::str_replace("html$", "pdf") %>%
    fs::path(output, .)
}


file = paste0("file://", normalizePath(input))

webshot::webshot(file, output)
