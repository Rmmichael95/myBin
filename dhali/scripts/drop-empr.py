#!/usr/bin/env python

import pandas as pd

in_file = "master-archive-clean.csv"
out_file = "new-master-archive-clean.csv"

# Load the CSV file into a DataFrame
df = pd.read_csv(in_file, dtype=str, on_bad_lines="skip")

# Remove the specified column
df.drop_duplicates(keep=False)

# write to file
df.to_csv(out_file, index=False)
