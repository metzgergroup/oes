#!/bin/bash

# Directories
source_dir="docker-scripts/data"

# Remove redundant data file
echo "Removing redundant data file..."
rm -f ${source_dir}/*.AllData

echo

# # Rename files
# prefix_pattern=oe\.
# suffix_pattern=\.[0-9]*
# for file in ${source_dir}/oe.*; do
#     if [[ $file =~ "txt" ]]
#     then
#         echo "Renaming ${file} to ${file/oe/README}..."
#         mv $file ${file/oe/README}
#     else
#         prefix_removed=${file/$prefix_pattern/}
#         prefix_and_suffix_removed=${prefix_removed%%$suffix_pattern}
#         new_filename=${prefix_and_suffix_removed}.txt
#         echo "Renaming ${file} to ${new_filename}..."
#         mv $file ${new_filename}
#     fi
# done

# echo

# Convert source files to Unix format
find ${source_dir}/* -type f ! -name *.tar.gz -exec dos2unix {} \;

echo

# Sanitize data in source files
echo "Sanitizing source files..."

# For files with a mandatory last field:
# (1) Remove trailing spaces and tabs
# (2) Reduce multiple spaces to single spaces
# (3) Replace a space followed by a tab with just a tab
# (4) Replace a tab followed by a space with just a tab
# (5) Replace all tabs with pipes (for delimiter)
sed1="sed -e 's/[ \t]*$//' -e 's/ \+/ /g' -e 's/ \t/\t/g' -e 's/\t /\t/g' -e 's/\t/|/g'"
eval ${sed1} -i ${source_dir}/oe.area
eval ${sed1} -i ${source_dir}/oe.areatype
eval ${sed1} -i ${source_dir}/oe.datatype
eval ${sed1} -i ${source_dir}/oe.footnote
eval ${sed1} -i ${source_dir}/oe.industry
eval ${sed1} -i ${source_dir}/oe.occupation
eval ${sed1} -i ${source_dir}/oe.seasonal
eval ${sed1} -i ${source_dir}/oe.sector
eval ${sed1} -i ${source_dir}/oe.series

# For files with an optional last field:
# (1) Remove all spaces (but leave tabs)
# (2) Replace multiple trailing tabs with a single tab (error in dataset)
# (3) Remove hyphens when surrounded by tabs (used to indicate null values)
# (4) Remove all commas
# (5) Replace all tabs with pipes (for delimiter)
sed2="sed -e 's/ \+//g' -e 's/\t\+$/\t/g' -e 's/\t-\t/\t\t/g' -e 's/,//g' -e 's/\t/|/g'"
eval ${sed2} -i ${source_dir}/oe.data*

echo

# Remove first line (header) from each data file
echo "Removing header lines from data files..."
for file in ${source_dir}/*; do
    if [[ $file != *oe.txt && $file != *oe.contacts && $file != *.tar.gz ]]
    then
        sed -i '1d' ${file}
    fi
done

echo

echo "Done."
