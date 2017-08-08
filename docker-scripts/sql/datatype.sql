\echo datatype

CREATE UNLOGGED TABLE datatype (
  datatype_code TEXT PRIMARY KEY,
  datatype_name TEXT NOT NULL
);

\set filepath `echo ${DATA_DIR}`/oe.datatype.txt
COPY datatype (datatype_code, datatype_name) FROM :'filepath' WITH DELIMITER '|';

ALTER TABLE datatype SET LOGGED;

\echo
