#!/usr/bin/env Rscript
library(dplyr)
library(data.table)
# Read each CSV file into a data frame
files <- list.files(pattern = "*.csv")
dfs <- lapply(files, read.csv, header=True)

# Combine the data frames
combined_df <- Reduce(function(...) merge(..., by = "Email", all = TRUE), dfs)
clean_df <- distinct(combined_df)
fwrite(clean_df, "combine.csv")
