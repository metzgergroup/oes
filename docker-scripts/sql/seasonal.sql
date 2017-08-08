\echo seasonal

CREATE UNLOGGED TABLE seasonal (
  seasonal TEXT PRIMARY KEY,
  seasonal_text TEXT NOT NULL
);

\set filepath `echo ${DATA_DIR}`/oe.seasonal.txt
COPY seasonal (seasonal, seasonal_text) FROM :'filepath' WITH DELIMITER '|';

ALTER TABLE seasonal SET LOGGED;

\echo
