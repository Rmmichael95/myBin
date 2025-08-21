#!/usr/bin/python
# importing libraries
import glob
import os

import pandas as pd

# merging the files
joined_files = os.path.join("/home/ryanm/DhaliMasterList/archive/", "*.csv")

# A list of all joined files is returned
joined_list = glob.glob(joined_files)

# Finally, the files are joined
df = pd.concat(map(pd.read_csv, joined_list), ignore_index=True)
df.to_csv("/home/ryanm/documents/merged.csv")
