\echo occupation

CREATE TABLE occupation (
  occupation_code CHAR(6) PRIMARY KEY,
  occupation_name TEXT NOT NULL,
  display_level INTEGER NOT NULL,
  selectable CHAR(1) NOT NULL,
  sort_sequence INTEGER NOT NULL
);

\set filepath `echo ${DATA_DIR}`/oe.occupation
COPY occupation (occupation_code, occupation_name, display_level, selectable, sort_sequence) FROM :'filepath';

\echo
