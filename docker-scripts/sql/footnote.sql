\echo footnote

CREATE UNLOGGED TABLE footnote (
  footnote_code INTEGER PRIMARY KEY,
  footnote_text TEXT NOT NULL
);

\set filepath `echo ${DATA_DIR}`/oe.footnote
COPY footnote (footnote_code, footnote_text) FROM :'filepath' WITH DELIMITER '|';

ALTER TABLE footnote SET LOGGED;

\echo
