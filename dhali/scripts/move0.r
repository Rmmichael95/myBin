#!/usr/bin/env Rscript
library(dplyr)
library(data.table)

file = "master-archive-clean.csv"
new_file = "new-master-archive-clean.csv"

move_col = "Unsubscribe Date (UTC-05)"
after_col = "Subscribe Date (UTC-05)"

# Read each CSV file into a data frame
df <- read.csv(file, stringsAsFactors = FALSE, check.names = FALSE, header = TRUE, sep = ",")

df %>% relocate(move_col, .after = after_col)

# Write to file
fwrite(new_df, new_file)
