#!/usr/bin/env Rscript
library(dplyr)
library(data.table)

# Read each CSV file into a data frame
df <- read.csv("masterArchive-clean.csv", header = TRUE, sep = ",")

new_df <- relocate(df, Unsubscribe.Date..UTC.05., .after = Subscribe.Date..UTC.05.)

# Write to file
fwrite(new_df, "new-masterArchive-clean.csv")
