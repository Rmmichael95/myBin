#!/usr/bin/env python

# import
import pandas as pd

in_file = "master-archive-clean.csv"
out_file = "new-master-archive-clean.csv"

# Load the CSV file into a DataFrame
df = pd.read_csv(in_file, dtype=str, on_bad_lines="skip")

# write cols
for column in df.columns:
    df[column].to_csv(f"{column}.csv", index=False)
