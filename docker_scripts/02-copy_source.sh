#!/bin/bash

# Directories
working_dir="working"

# New database name
dbname="oes"

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
for table in ${tables[@]}; do
    psql \
        --username=${POSTGRES_USER} \
        --dbname=${dbname} \
        --command="COPY ${table} FROM '/${working_dir}/${table}' WITH NULL '';"
done
echo "Copying complete."

echo "Done."