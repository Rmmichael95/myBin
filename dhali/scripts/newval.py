#!/usr/bin/env python

# import
import pandas as pd

in_file = "master-archive-clean.csv"
out_file = "new-master-archive-clean.csv"

term = "SLO"

# Load the CSV file into a DataFrame
df = pd.read_csv(in_file, dtype=str, on_bad_lines="skip")

# get col
with open("nums.txt", "r") as file:
    nums = [int(line.strip()) for line in file]

df.loc[nums, "General Contact Profile\\Database"] = term

# write to file
df.to_csv(out_file, index=False)
