#!/usr/bin/env Rscript
library(dplyr)
library(data.table)

in-file = "master-archive-clean.csv"
out-file = "new-master-archive-clean.csv"

# Read each CSV file into a data frame
df <- read.csv(in-file, check.names = FALSE, header = TRUE, sep = ",")

# Clean the data frames
new_df <- !distinct(df)

fwrite(new_df, out-file)
