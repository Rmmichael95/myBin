#!/usr/bin/env python

import glob

import pandas as pd

# Get a list of all CSV files in the directory
csv_files = glob.glob("path/to/csv/files/*.csv")


out_file = "new-master-archive-clean.csv"

field = "WFG"

df = pd.DataFrame()

for csv_file in csv_files:
    # Load the CSV file into a DataFrame
    df = pd.read_csv(csv_file, dtype=str, on_bad_lines="skip")

# Remove the specified column
df.drop(field, axis=1, inplace=True)

# write to file
df.to_csv(out_file, index=False)
