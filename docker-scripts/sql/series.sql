\echo series

CREATE TABLE series (
  series_id CHAR(30) PRIMARY KEY,
  seasonal CHAR(1) NOT NULL REFERENCES seasonal(seasonal),
  areatype_code CHAR(1) NOT NULL REFERENCES areatype(areatype_code),
  industry_code CHAR(6) NOT NULL REFERENCES industry(industry_code),
  occupation_code CHAR(6) NOT NULL REFERENCES occupation(occupation_code),
  datatype_code CHAR(2) NOT NULL REFERENCES datatype(datatype_code),
  state_code CHAR(2) NOT NULL,
  area_code CHAR(7) NOT NULL,
  sector_code CHAR(6) REFERENCES sector(sector_code),
  series_title TEXT NOT NULL,
  footnote_codes TEXT REFERENCES footnote(footnote_code),
  begin_year INTEGER NOT NULL,
  begin_period CHAR(3) NOT NULL,
  end_year INTEGER NOT NULL,
  end_period CHAR(3) NOT NULL,
  FOREIGN KEY (state_code, area_code) REFERENCES area(state_code, area_code)
);

\set filepath `echo ${DATA_DIR}`/oe.series
COPY series (series_id, seasonal, areatype_code, industry_code, occupation_code, datatype_code, state_code, area_code, sector_code, series_title, footnote_codes, begin_year, begin_period, end_year, end_period) FROM :'filepath' WITH NULL '';

\echo
