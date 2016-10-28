\echo industry

CREATE TABLE industry (
  industry_code TEXT PRIMARY KEY,
  industry_name TEXT NOT NULL,
  display_level INTEGER NOT NULL,
  selectable TEXT NOT NULL,
  sort_sequence INTEGER NOT NULL
);

\set filepath `echo ${DATA_DIR}`/oe.industry
COPY industry (industry_code, industry_name, display_level, selectable, sort_sequence) FROM :'filepath' WITH DELIMITER '|';

\echo
