\echo sector

CREATE TABLE sector (
  sector_code CHAR(6) PRIMARY KEY,
  sector_name TEXT NOT NULL
);

\set filepath `echo ${DATA_DIR}`/oe.sector
COPY sector (sector_code, sector_name) FROM :'filepath';

\echo
