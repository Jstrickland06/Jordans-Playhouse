#!/bin/bash
# Jordan Strickland
# My simple script to clean Olive Garden menu text

echo "Item,Price,Calories"

# Read 3 lines at a time from the raw file
while read item && read price && read calories
do
    # Remove commas from item names (prevents CSV break)
    clean_item=$(echo "$item" | sed 's/,//g')
    echo "$clean_item,$price,$calories"
done < olive_raw.txt
