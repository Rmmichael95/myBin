#!/usr/bin/python
# importing pandas
import pandas as pd

# merging two csv files
df = pd.concat(map(pd.read_csv, ["mydata.csv", "mydata1.csv"]), ignore_index=True)
df.to_csv("join.csv")
