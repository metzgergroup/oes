\echo
\echo Creating tables and copying data...
\echo

-- Set current directory to the first script file's location so we can use relative includes below
\cd `echo ${HERE}`

-- Order is based on dependencies
\ir sql/areatype.sql
\ir sql/footnote.sql
\ir sql/industry.sql
\ir sql/occupation.sql
\ir sql/seasonal.sql
\ir sql/sector.sql
\ir sql/area.sql
\ir sql/datatype.sql
\ir sql/series.sql
\ir sql/data.sql

\echo Done.
