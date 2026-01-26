## 
# Script to create a .qmd source file that prints out a 
# formatted, more navigable and legible .qmd source. 
#
library(htmltools)


make_year_h2 <- function(year) {
  return (
    paste0("\n\n<h2 id='", year, "'>", year, "</h2>\n\n")
  )
}


# Specify where data is located
path <- "data/emails.rds"

# Load and order the entries by date—entries missing dates go last
emails <- readRDS(path) |> dplyr::arrange(sent_at)

entries <- character(nrow(emails))
year <- NA_integer_

DEBUG = T
REACHED_UNDATED <- FALSE
# Loop over emails to track and print changes in year
for (i in seq_len(nrow(emails))) {

  # Get email to process in row i
  row <- emails[i, ]
  # Extract the year
  this_year <- lubridate::year(row$sent_at)

  if (DEBUG) {
    # Clear screen and print progress for debugging
    cat("\014")
    cat("Processing email", i, "of", nrow(emails), "\n")
    cat("From:", row$from, "\n")
    cat("To:", row$to, "\n")
    cat("CC:", row$cc, "\n")
    cat("Date:", format(row$sent_at, "%b %d, %Y"), "\n")
    cat("Subject:", row$subject, "\n")
  }
  
  # By default we do not add an h2 heading for the year
  year_h2 <- ""
    # print(year)
    # print(this_year)
  # If year is na and this_year is not, or if this_year is greater than
  # year, then add a h2-level heading to separate years.
  
  if (!is.na(this_year)) {
    if ((is.na(year) || this_year > year)) {
      year <- this_year
      year_h2 <- make_year_h2(year)
    }
  } else if(!REACHED_UNDATED)  {
    year_h2 <- make_year_h2("Undated")
    REACHED_UNDATED <- TRUE
  }

  entry_id <- gsub("\\s+", "-", tolower(row$doc_id))

  entries[i] <- paste0(
    year_h2,
    "\n<h3 id='", entry_id,"'>", htmlEscape(row$sent_at), "</h3>\n\n",
    "<h4>From: ", htmlEscape(row$from), "</h4>\n\n",
    "<h4>To: ", htmlEscape(row$to), "</h4>\n\n",
    "<h4>CC: ", htmlEscape(row$cc), "</h4>\n\n",
    "<h4>Subject: ", htmlEscape(row$subject), "</h4>\n\n",
    "<h5>", htmlEscape(row$doc_id), "</h5>\n\n",
    "<pre>\n", htmlEscape(row$body), "</pre>\n\n"
  )
}

quarto_stuff <- 
r"(---
title: Epstein Emails from November 25, 2025 release
format: html
toc: false
---
<p><i style="color: darkred">It is powerful until seen and is active; ignorance is the mother of all evil; It will end in death!</i></p>
<p><i style="color: darkred">For those who come from this, iniquity cease to exist.</i></p>

<br>

## Table of Contents

- [2009](#2009)
- [2010](#2010)
- [2011](#2011)
- [2012](#2012)
- [2013](#2013)
- [2014](#2014)
- [2015](#2015)
- [2016](#2016)
- [2017](#2017)
- [2018](#2018)
- [2019](#2019)
- [Undated$^*$](#undated)

### Notable emails

- [A reporter seeking comment on katie johnson v. trump lawsuit (4/28/2026)](#house-oversight-032067)
- [Jeff sent writing to Arianna Huff to run cover via Peggy
   Siegal (July 1, 2011)](#house-oversight-032157); Peggy also asks Jeffrey, "Did you know why
Prince Alberts Charlene fled to the airport with a one way ticket back to South
Africa? Because she found out about a third illegitimate child that is 3 months
old...the palace officials followed her to the airport and propably made her an
offer she could not refuse.. will get details from Jim Coleman when he comes
home Sunday night.  In Southampton now. Peg"
- A female helper...
  - [talking about having new "assistants" for Jeffrey](#house-oversight-033178) and talking about missing Berkeley (Oct  19, 2016)
  - [checking to see if Jeffrey has any lawering work to do in NY when she graduates Berkeley](#house-oversight-032374), asks if Jeffrey is happy about Trump election (Nov. 16, 2016)
- [Exchange with Sultan Bin Sulayem (Emirati businessman, 9/22/2011)](#house-oversight-032106) that includes Sulayem sending a bunch of press releases for a shoe that can track people. Jeffrey tells Sulayem "It is always fun to see you".

```{=html}
)"
lines <- c(quarto_stuff, entries, "```")

write_lines(lines, "epstein-formatted-txt-2025-11-25-release.qmd")
# # Set up entry creator; track the current year, creating a new 
# # h2 section for every year
# year <- 0
# create_entry <- function(...) {

#   row <- list(...)
#   this_year <- lubridate::year(row$sent_at)

#   year_h2 <- ""

#   if (!is.na(year) || this_year > year) {
#     year <- this_year
#     year_h2 <- make_year_h2(year)
#   } 

#   return (
#     paste0(
#       year_h2,  # will be empty string if year didn't change
#       "\n<h3> ", row$sent_at, "</h3>\n\n",
#       "<h4>From: ", row$from, "</h4>\n\n", 
#       "<h4>To: ", row$from, "</h4>\n\n", 
#       "<h4>CC: ", row$cc, "</h4>\n\n", 
#       "<h4>Subject: ", row$subject, "</h4>\n\n", 
#       "<h5>", row$doc_id, "</h5>\n\n", 
#       "<p>\n", row$body, "</p>\n\n"
#     )
#   )
# }



