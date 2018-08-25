\echo area

CREATE UNLOGGED TABLE area (
  state_code TEXT NOT NULL,
  area_code TEXT NOT NULL,
  areatype_code TEXT NOT NULL REFERENCES areatype(areatype_code),
  area_name TEXT NOT NULL,
  PRIMARY KEY (state_code, area_code)
);

\set filepath `echo ${DATA_DIR}`/oe.area
COPY area (state_code, area_code, areatype_code, area_name) FROM :'filepath' WITH DELIMITER '|';

ALTER TABLE area SET LOGGED;

\echo
