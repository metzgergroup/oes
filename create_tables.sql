CREATE TABLE areatype (
  areatype_code CHAR(1) PRIMARY KEY,
  areatype_name TEXT NOT NULL
);

CREATE TABLE area (
  state_code CHAR(2) NOT NULL,
  area_code CHAR(7) NOT NULL,
  areatype_code CHAR(1) NOT NULL REFERENCES areatype(areatype_code),
  area_name TEXT NOT NULL,
  PRIMARY KEY (state_code, area_code)
);

CREATE TABLE industry (
  industry_code CHAR(6) PRIMARY KEY,
  industry_name TEXT NOT NULL,
  display_level INTEGER NOT NULL,
  selectable CHAR(1) NOT NULL,
  sort_sequence INTEGER NOT NULL
);

CREATE TABLE occupation (
  occupation_code CHAR(6) PRIMARY KEY,
  occupation_name TEXT NOT NULL,
  display_level INTEGER NOT NULL,
  selectable CHAR(1) NOT NULL,
  sort_sequence INTEGER NOT NULL
);

CREATE TABLE datatype (
  datatype_code CHAR(2) PRIMARY KEY,
  datatype_name TEXT NOT NULL
);

CREATE TABLE sector (
  sector_code CHAR(6) PRIMARY KEY,
  sector_name TEXT NOT NULL
);

CREATE TABLE footnote (
  footnote_code CHAR(1) PRIMARY KEY,
  footnote_text TEXT NOT NULL
);

CREATE TABLE seasonal (
  seasonal CHAR(1) PRIMARY KEY,
  seasonal_text TEXT NOT NULL
);

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

CREATE TABLE data (
  series_id CHAR(30) PRIMARY KEY REFERENCES series(series_id),
  year INTEGER NOT NULL,
  period CHAR(3) NOT NULL,
  value TEXT NOT NULL,
  footnote_code TEXT REFERENCES footnote(footnote_code)
);
