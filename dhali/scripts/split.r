#!/usr/bin/env Rscript

# read csv into r
df <- read.csv("masterArchive-clean-1k.csv", header = TRUE, sep = ",")

for (col in names(df)) {
    filename <- paste(col, ".csv", sep = "")

    # write to csv
    write.csv(df[, col], file = filename, row.names = FALSE)
}
