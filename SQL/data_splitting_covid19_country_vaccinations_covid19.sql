CREATE TABLE case_test AS SELECT 
	location, date,
	# CASES, TESTS
	total_cases,
	new_cases,
	total_cases_per_million,
	new_cases_smoothed,
	new_cases_per_million,
	new_cases_smoothed_per_million,
	tests_units,
	total_tests,	
	new_tests,				
	total_tests_per_thousand,			  
	new_tests_per_thousand,		
	new_tests_smoothed,
	new_tests_smoothed_per_thousand,
	positive_rate,
	tests_per_case
FROM covid19data_sem6_grp2;
SELECT * FROM case_test;

CREATE TABLE death AS SELECT
	location, date,
	# DEATHS
	total_deaths,
	new_deaths,
	new_deaths_smoothed,
	total_deaths_per_million,
	new_deaths_per_million,
	new_deaths_smoothed_per_million
FROM covid19data_sem6_grp2;
SELECT * FROM death;

CREATE TABLE hospital AS SELECT
	location, date,
	#HOSPITAL		
	icu_patients,
	icu_patients_per_million,		
	hosp_patients,			
	hosp_patients_per_million,		
	weekly_icu_admissions,			
	weekly_icu_admissions_per_million,	
	weekly_hosp_admissions,	
	weekly_hosp_admissions_per_million
FROM covid19data_sem6_grp2;
SELECT * FROM hospital;

CREATE TABLE vaccination AS
SELECT * FROM country_vaccinations_sem6_grp2
NATURAL JOIN 
(
SELECT location, date, new_vaccinations, new_vaccinations_smoothed, new_vaccinations_smoothed_per_million FROM covid19data_sem6_grp2
) t;
#ON country_vaccinations_sem6_grp2.location = t.location AND country_vaccinations_sem6_grp2.date = t.date;
SELECT * FROM vaccination;

CREATE TABLE disease AS SELECT 
	location, date,
	# DISEASE
	stringency_index,
	excess_mortality,
	reproduction_rate
FROM covid19data_sem6_grp2;

DROP TABLE covid19data;
DROP TABLE covid19data_sem6_grp2;
DROP TABLE country_vaccinations;
DROP TABLE country_vaccinations_sem6_grp2;