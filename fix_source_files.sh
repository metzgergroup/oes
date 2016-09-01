#!/bin/bash

# Directories
source_dir="source"
working_dir="working"

# Create working directory
echo "Creating working directory..."
mkdir -p ${working_dir}
echo "Directory created."

# Convert source files to Unix format
echo "Converting to Unix format..."
find ${source_dir} -type f -name "oe.*" -exec dos2unix {} \;
echo "Files now in Unix format."

# Sanitize data in source files
echo "Sanitizing source files and copying to working directory..."

# For files with a mandatory last field:
# (1) Remove trailing spaces and tabs
# (2) Reduce multiple spaces to single spaces
# (3) Replace a space followed by a tab with just a tab
sed1="sed -e 's/[ \t]*$//' -e 's/ \+/ /g' -e 's/ \t/\t/g'"
eval ${sed1} <${source_dir}/oe.area >${working_dir}/area
eval ${sed1} <${source_dir}/oe.areatype >${working_dir}/areatype
eval ${sed1} <${source_dir}/oe.datatype >${working_dir}/datatype
eval ${sed1} <${source_dir}/oe.footnote >${working_dir}/footnote
eval ${sed1} <${source_dir}/oe.industry >${working_dir}/industry
eval ${sed1} <${source_dir}/oe.occupation >${working_dir}/occupation
eval ${sed1} <${source_dir}/oe.seasonal >${working_dir}/seasonal
eval ${sed1} <${source_dir}/oe.sector >${working_dir}/sector
eval ${sed1} <${source_dir}/oe.series >${working_dir}/series

# For files with an optional last field:
# (1) Remove trailing spaces (but leave tabs)
# (2) Reduce multiple spaces to single spaces
# (3) Replace a space followed by a tab with just a tab
# (4) Replace multiple trailing tabs with a single tab
sed2="sed -e 's/ *$//' -e 's/ \+/ /g' -e 's/ \t/\t/g' -e 's/\t\+$/\t/g'"
eval ${sed2} <${source_dir}/oe.data.0.Current >${working_dir}/data

echo "Files sanitized."

# Remove first line (header) from each file
echo "Removing header lines from files..."
for file in ${working_dir}/*; do
    sed -i '1d' ${file}
done
echo "Header lines removed."

echo "Done."