#!/usr/bin/env Rscript

# get library to write to csv
library(data.table)

# read csv into r
df <- read.csv("masterArchive-clean-1k.csv", header = TRUE, sep = ",")

# make each value a string
str_df <- as.data.frame(lapply(df, as.character))

# write to csv
fwrite(str_df, "ArchiveStr.csv")
