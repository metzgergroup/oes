\echo seasonal

CREATE TABLE seasonal (
  seasonal CHAR(1) PRIMARY KEY,
  seasonal_text TEXT NOT NULL
);

\set filepath `echo ${DATA_DIR}`/oe.seasonal
COPY seasonal (seasonal, seasonal_text) FROM :'filepath';

\echo
