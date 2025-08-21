#!/usr/bin/sh

# full file name
file="master-archive-orig.csv"
# remove file ext
name="${file%.*}"
# get line count
lines=$(wc -l <"$file")
# num to divide by
count=500000

# count files parts
i=1
while [ "$lines" -ge "$count" ]; do
    # new file name
    new_file="$name-part$i.csv"
    # copy first $count lines to new file
    head -n "$count" "$file" >"$new_file"
    # delete from line 2 till $count
    sed -i -e "2,$count"d "$file"
    # subtract count from our line num record
    lines=$((lines - count))
    # increment file count
    i=$((i + 1))
done

#move remaining to last file
mv "$file" "$name-part$i.csv"
