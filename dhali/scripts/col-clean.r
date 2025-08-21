#!/usr/bin/env Rscript

library(janitor)
library(data.table)

# Read each CSV file into a data frame
df <- read.csv("masterArchive.csv", check.name = FALSE, header = TRUE, sep = ",")

clean_df <- remove_empty(df, which = "cols")

fwrite(clean_df, "masterArchive-clean.csv")
