\echo occupation

CREATE UNLOGGED TABLE occupation (
  occupation_code TEXT PRIMARY KEY,
  occupation_name TEXT NOT NULL,
  display_level INTEGER NOT NULL,
  selectable TEXT NOT NULL,
  sort_sequence INTEGER NOT NULL
);

\set filepath `echo ${DATA_DIR}`/oe.occupation.txt
COPY occupation (occupation_code, occupation_name, display_level, selectable, sort_sequence) FROM :'filepath' WITH DELIMITER '|';

ALTER TABLE occupation SET LOGGED;

\echo
