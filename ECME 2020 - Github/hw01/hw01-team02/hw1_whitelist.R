allowed_files = c("hw1.md",
                  "hw1.Rmd",
                  "README.md",
                  "hw1.Rproj",
                  "hw1_whitelist.R",
                  "fizzbuzz.png",
                  ".gitignore",
                  "data.csv")

files = dir()
disallowed_files = files[!(files %in% allowed_files)]

if (length(disallowed_files != 0)) {
  cat("Disallowed files found:\n")
  cat("  (remove the following files from your repo)\n\n")

  for (file in disallowed_files)
    cat("*", file, "\n")

  quit("no", 1, FALSE)
}
