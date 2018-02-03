allowed_files = c("hw6.Rmd",
                  "README.md",
                  "wercker.yml",
                  "hw6.Rproj",
                  "hw6_whitelist.R",
                  "precincts.geojson")

files = dir()
disallowed_files = files[!(files %in% allowed_files)]

if (length(disallowed_files != 0))
{
  cat("Disallowed files found:\n")
  cat("  (remove the following files from your repo)\n\n")

  for(file in disallowed_files)
    cat("*",file,"\n")

  quit("no",1,FALSE)
}
