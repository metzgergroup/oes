\echo areatype

CREATE UNLOGGED TABLE areatype (
  areatype_code TEXT PRIMARY KEY,
  areatype_name TEXT NOT NULL
);

\set filepath `echo ${DATA_DIR}`/oe.areatype.txt
COPY areatype (areatype_code, areatype_name) FROM :'filepath' WITH DELIMITER '|';

ALTER TABLE areatype SET LOGGED;

\echo
