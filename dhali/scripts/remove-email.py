#!/usr/bin/env python

import pandas as pd

# Get a list of all CSV files in the directory
file1 = "2025-master-list.csv"
file2 = "prod.csv"
out_file = "new-prod.csv"


# Load the CSV file into a DataFrame
df1 = pd.read_csv(file1, dtype=str, on_bad_lines="skip")
df2 = pd.read_csv(file2, dtype=str, on_bad_lines="skip")

# Remove rows from df2 that do not appear in df1
df2_filtered = df2[df2["Email"].isin(df1["Email"])]

# write to file
df2_filtered.to_csv(out_file, index=False)
