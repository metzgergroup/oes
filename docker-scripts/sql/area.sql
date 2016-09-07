\echo area

CREATE TABLE area (
  state_code CHAR(2) NOT NULL,
  area_code CHAR(7) NOT NULL,
  areatype_code CHAR(1) NOT NULL REFERENCES areatype(areatype_code),
  area_name TEXT NOT NULL,
  PRIMARY KEY (state_code, area_code)
);

\set filepath `echo ${DATA_DIR}`/oe.area
COPY area (state_code, area_code, areatype_code, area_name) FROM :'filepath';

\echo