#!/usr/bin/env Rscript
library(dplyr)
library(data.table)
# Read each CSV file into a data frame
df <- read.csv("master-archive-2025.csv", header = TRUE, sep = ",")

# Combine the data frames
clean_df <- df[, !duplicated(colnames(df), fromLast = TRUE)]
fwrite(clean_df, "cleaned.csv")
