#!/usr/bin/sh

# awk -F',' -v OFS=',' -v search="$(awk -F',' '{print $1}' as-is-lists/xx-dbs-prior-to-9-10-update/Advanced-Management.csv)" -v replace="Management" '
#   $1 == search { $4 = replace }
#   { print }
# ' archive/master-archive.csv >processed-master-archive.csv

awk -F '|' -v OFS='|' '$16 == "Market1" { $16 = "MarketPrime" }1' file.csv >new-file.csv
