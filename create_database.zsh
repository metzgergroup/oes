#!/bin/zsh

# Directories to create for files
original="original"
working="working"

# New database name
oes="oes"

# Create directories
echo "Creating directories..."
mkdir -p ${original}
mkdir -p ${working}
echo "Directories created."

# Move original source files to directory
echo "Moving source files..."
mv oe.* ${original}
echo "Source files moved."

# Convert source files to Unix format
echo "Converting to Unix format..."
find ${original} -type f -name "oe.*" -exec dos2unix {} \;
echo "Files now in Unix format."

# Sanitize data in source files
echo "Sanitizing source files and copying to ${working} directory..."

# For files with a mandatory last field:
# (1) Remove trailing spaces and tabs
# (2) Reduce multiple spaces to single spaces
# (3) Replace a space followed by a tab with just a tab
sed1="sed -e 's/[ \t]*$//' -e 's/ \+/ /g' -e 's/ \t/\t/g'"
eval ${sed1} <${original}/oe.area >${working}/area
eval ${sed1} <${original}/oe.areatype >${working}/areatype
eval ${sed1} <${original}/oe.datatype >${working}/datatype
eval ${sed1} <${original}/oe.footnote >${working}/footnote
eval ${sed1} <${original}/oe.industry >${working}/industry
eval ${sed1} <${original}/oe.occupation >${working}/occupation
eval ${sed1} <${original}/oe.seasonal >${working}/seasonal
eval ${sed1} <${original}/oe.sector >${working}/sector
eval ${sed1} <${original}/oe.series >${working}/series

# For files with an optional last field:
# (1) Remove trailing spaces (but leave tabs)
# (2) Reduce multiple spaces to single spaces
# (3) Replace a space followed by a tab with just a tab
# (4) Replace multiple trailing tabs with a single tab
sed2="sed -e 's/ *$//' -e 's/ \+/ /g' -e 's/ \t/\t/g' -e 's/\t\+$/\t/g'"
eval ${sed2} <${original}/oe.data.0.Current >${working}/data

echo "Files sanitized."

# Remove first line (header) from each file
echo "Removing header lines from files..."
for file (${working}/*) sed -i '1d' $file
echo "Header lines removed."

# Create empty database
echo "Creating database named ${oes}..."
createdb ${oes}
echo "Database created."

# Add tables to database
echo "Creating tables in ${oes}..."
psql -f create_tables.sql ${oes}
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
    psql --command="COPY ${table} FROM '${PWD}/${working}/${table}' WITH NULL '';" --dbname=${oes}
done
echo "Copying complete."

# Create backup
echo "Backing up to ${oes}.dump..."
pg_dump --format=custom ${oes} > ${oes}.dump
echo "Backup complete."