\echo data

CREATE UNLOGGED TABLE data (
  series_id TEXT PRIMARY KEY REFERENCES series(series_id),
  year INTEGER NOT NULL,
  period TEXT NOT NULL,
  value DECIMAL,
  footnote_code INTEGER REFERENCES footnote(footnote_code)
);

\set filepath `echo ${DATA_DIR}`/oe.data.0.Current
COPY data (series_id, year, period, value, footnote_code) FROM :'filepath' WITH DELIMITER '|' NULL '';

ALTER TABLE data SET LOGGED;

\echo
