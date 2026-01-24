## 
# Script to create a .qmd source file that prints out a 
# formatted, more navigable and legible .qmd source. 
#
library(readr)
library(dplyr)
library(purrr)


path <- "data/all_emails_raw.csv"


# Build the list of entries to join, 
emails <- read_csv2(path) |> arrange(sent_at)

# Set up entry creator; track the current year, creating a new 
# h2 section for every year
create_entry <- function(...) {

  row <- list(...)

  return (
    paste0("\n<h3> ", row$sent_at, "</h3>\n\n<p>\n", row$body, "</p>\n\n")
  )
}


# pmap_vec(create_entry)


