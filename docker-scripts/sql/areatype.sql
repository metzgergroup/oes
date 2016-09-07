\echo areatype

CREATE TABLE areatype (
  areatype_code CHAR(1) PRIMARY KEY,
  areatype_name TEXT NOT NULL
);

\set filepath `echo ${DATA_DIR}`/oe.areatype
COPY areatype (areatype_code, areatype_name) FROM :'filepath';

\echo
