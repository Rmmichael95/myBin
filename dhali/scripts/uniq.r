#!/usr/bin/env Rscript
library(dplyr)
library(data.table)

# Read each CSV file into a data frame
df <- read.csv("master-archive.csv", check.names = FALSE, header = TRUE, sep = ",")

# Clean the data frames
clean_head_df <- df[, !duplicated(colnames(df), fromLast = TRUE)]
clean_df <- distinct(clean_head_df)
fwrite(clean_df, "masterArchive.csv")
