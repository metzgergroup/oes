\echo data

CREATE TABLE data (
  series_id CHAR(30) PRIMARY KEY REFERENCES series(series_id),
  year INTEGER NOT NULL,
  period CHAR(3) NOT NULL,
  value TEXT NOT NULL,
  footnote_code TEXT REFERENCES footnote(footnote_code)
);

\set filepath `echo ${DATA_DIR}`/oe.data.0.Current
COPY data (series_id, year, period, value, footnote_code) FROM :'filepath' WITH NULL '';

\echo
