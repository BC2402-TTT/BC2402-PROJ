SET SQL_SAFE_UPDATES = 0;

SELECT * FROM cases;
DELETE FROM cases
WHERE	total_cases						is null or 0
    AND	new_cases						is null or 0
    AND total_cases_per_million			is null or 0
    AND new_cases_smoothed				is null or 0
    AND new_cases_per_million			is null or 0
    AND new_cases_smoothed_per_million	is null or 0;
SELECT * FROM cases;

SELECT * FROM deaths;
DELETE FROM deaths
WHERE	total_deaths 					is null or 0
	AND new_deaths						is null or 0
	AND	new_deaths_smoothed				is null or 0
	AND	total_deaths_per_million		is null or 0
	AND	new_deaths_per_million			is null or 0
	AND	new_deaths_smoothed_per_million	is null or 0;
SELECT * FROM deaths;

SELECT * FROM diseases;
DELETE FROM diseases
WHERE	stringency_index				is null or 0
	AND excess_mortality				is null or 0
	AND	reproduction_rate				is null or 0;
SELECT * FROM diseases;

SELECT * FROM hospitals;
DELETE FROM hospitals
WHERE	icu_patients						is null or 0
	AND icu_patients_per_million			is null or 0
	AND	hosp_patients						is null or 0
    AND hosp_patients_per_million		 	is null or 0
    AND weekly_icu_admissions				is null or 0
    AND weekly_icu_admissions_per_million	is null or 0
    AND weekly_hosp_admissions				is null or 0
    AND weekly_hosp_admissions_per_million	is null or 0;
SELECT * FROM hospitals;

SELECT * FROM tests;
DELETE FROM tests
WHERE	tests_units						is null or 0
	AND total_tests						is null or 0
	AND	new_tests						is null or 0
    AND total_tests_per_thousand	 	is null or 0
    AND new_tests_per_thousand			is null or 0
    AND new_tests_smoothed				is null or 0
    AND new_tests_smoothed_per_thousand	is null or 0
    AND positive_rate					is null or 0
    AND tests_per_case					is null or 0;
SELECT * FROM tests;

SELECT * FROM vaccinations; #does not need cleaning

SELECT * FROM locations_sem6_grp2;

SELECT * FROM locations_sem6_grp2;

SELECT * FROM sources_sem6_grp2;

SELECT * FROM sources_sem6_grp2;

SET SQL_SAFE_UPDATES = 1;

DROP TABLE covid19data;
DROP TABLE covid19data_sem6_grp2;
DROP TABLE country_vaccinations;
DROP TABLE country_vaccinations_sem6_grp2;
DROP TABLE country_vaccinations_by_manufacturer;
DROP TABLE country_vaccinations_by_manufacturer_sem6_grp2;

SELECT COLUMN_NAME, DATA_TYPE from INFORMATION_SCHEMA.COLUMNS
WHERE table_name = "cases";

SELECT COLUMN_NAME, DATA_TYPE from INFORMATION_SCHEMA.COLUMNS
WHERE table_name = "tests";

SELECT COLUMN_NAME, DATA_TYPE from INFORMATION_SCHEMA.COLUMNS
WHERE table_name = "deaths";

SELECT COLUMN_NAME, DATA_TYPE from INFORMATION_SCHEMA.COLUMNS
WHERE table_name = "diseases";

SELECT COLUMN_NAME, DATA_TYPE from INFORMATION_SCHEMA.COLUMNS
WHERE table_name = "hospitals";

SELECT COLUMN_NAME, DATA_TYPE from INFORMATION_SCHEMA.COLUMNS
WHERE table_name = "locations_sem6_grp2";

SELECT COLUMN_NAME, DATA_TYPE from INFORMATION_SCHEMA.COLUMNS
WHERE table_name = "sources_sem6_grp2";

SELECT COLUMN_NAME, DATA_TYPE from INFORMATION_SCHEMA.COLUMNS
WHERE table_name = "vaccinations";