#!/bin/zsh

# Directories
source_dir="source_dir"
working_dir="working_dir"

# New database name
dbname="dbname"

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
for file (${working_dir}/*) sed -i '1d' $file
echo "Header lines removed."

# Create empty database
echo "Creating database named ${dbname}..."
createdb ${dbname}
echo "Database created."

# Add tables to database
echo "Creating tables in ${dbname}..."
psql --file=create_tables.sql --dbname=${dbname}
echo "Tables created."

# Tables listed based on dependencies
# (i.e., referenced tables precede referencing tables)
tables=(
    areatype
    footnote
    industry
    occupation
    seasonal
    sector
    area
    datatype
    series
    data
)

# Copy tab-delimited data from files into tables
echo "Copying data from source files to database..."
for table in ${tables}; do
    psql --command="COPY ${table} FROM '${PWD}/${working_dir}/${table}' WITH NULL '';" --dbname=${dbname}
done
echo "Copying complete."

# Create backup
echo "Backing up to ${dbname}.dump..."
pg_dump --format=custom ${dbname} > ${dbname}.dump
echo "Backup complete."

echo "Done."