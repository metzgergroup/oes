\echo seasonal

CREATE TABLE seasonal (
  seasonal TEXT PRIMARY KEY,
  seasonal_text TEXT NOT NULL
);

\set filepath `echo ${DATA_DIR}`/oe.seasonal
COPY seasonal (seasonal, seasonal_text) FROM :'filepath' WITH DELIMITER '|';

\echo
