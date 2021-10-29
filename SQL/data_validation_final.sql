SET SQL_SAFE_UPDATES = 0;

DELETE FROM tests
WHERE	total_tests						is null or 0
	AND	new_tests						is null or 0
    AND total_tests_per_thousand	 	is null or 0
    AND new_tests_per_thousand			is null or 0
    AND new_tests_smoothed				is null or 0
    AND new_tests_smoothed_per_thousand	is null or 0
    AND positive_rate					is null or 0
    AND tests_per_case					is null or 0;
SELECT * FROM tests;

DELETE FROM cases
WHERE	total_cases						is null or 0
    AND	new_cases						is null or 0
    AND total_cases_per_million			is null or 0
    AND new_cases_smoothed				is null or 0
    AND new_cases_per_million			is null or 0
    AND new_cases_smoothed_per_million	is null or 0
	AND	reproduction_rate				is null or 0;
SELECT * FROM cases;

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

DELETE FROM deaths
WHERE	total_deaths 					is null or 0
	AND new_deaths						is null or 0
	AND	new_deaths_smoothed				is null or 0
	AND	total_deaths_per_million		is null or 0
	AND	new_deaths_per_million			is null or 0
	AND	new_deaths_smoothed_per_million	is null or 0
	AND excess_mortality				is null or 0;
SELECT * FROM deaths;

#does not need cleaning due to no null rows:
SELECT * FROM stringency;
SELECT * FROM vaccinations; 
SELECT * FROM locations;
SELECT * FROM sources;

SET SQL_SAFE_UPDATES = 1;

DROP TABLE covid19data;
DROP TABLE covid19data_sem6_grp2;
DROP TABLE country_vaccinations;
DROP TABLE country_vaccinations_sem6_grp2;
DROP TABLE country_vaccinations_by_manufacturer;
