\echo series

CREATE UNLOGGED TABLE series (
  series_id TEXT PRIMARY KEY,
  seasonal TEXT NOT NULL REFERENCES seasonal(seasonal),
  areatype_code TEXT NOT NULL REFERENCES areatype(areatype_code),
  industry_code TEXT NOT NULL REFERENCES industry(industry_code),
  occupation_code TEXT NOT NULL REFERENCES occupation(occupation_code),
  datatype_code TEXT NOT NULL REFERENCES datatype(datatype_code),
  state_code TEXT NOT NULL,
  area_code TEXT NOT NULL,
  sector_code TEXT REFERENCES sector(sector_code),
  series_title TEXT NOT NULL,
  footnote_codes INTEGER REFERENCES footnote(footnote_code),
  begin_year INTEGER NOT NULL,
  begin_period TEXT NOT NULL,
  end_year INTEGER NOT NULL,
  end_period TEXT NOT NULL,
  FOREIGN KEY (state_code, area_code) REFERENCES area(state_code, area_code)
);

\set filepath `echo ${DATA_DIR}`/oe.series.txt
COPY series (series_id, seasonal, areatype_code, industry_code, occupation_code, datatype_code, state_code, area_code, sector_code, series_title, footnote_codes, begin_year, begin_period, end_year, end_period) FROM :'filepath' WITH DELIMITER '|' NULL '';

ALTER TABLE series SET LOGGED;

\echo
