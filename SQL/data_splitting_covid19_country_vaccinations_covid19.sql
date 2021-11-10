CREATE TABLE tests AS SELECT
	location, date,
	# TESTS
    tests_units,
	total_tests,	
	new_tests,				
	total_tests_per_thousand,			  
	new_tests_per_thousand,		
	new_tests_smoothed,
	new_tests_smoothed_per_thousand,
	positive_rate,
	tests_per_case
FROM covid19data_cleaned;

CREATE TABLE cases AS SELECT 
	location, date,
	# CASES
	total_cases,
	new_cases,
	total_cases_per_million,
	new_cases_smoothed,
	new_cases_per_million,
	new_cases_smoothed_per_million,
	reproduction_rate
FROM covid19data_cleaned;

CREATE TABLE hospitals AS SELECT
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
FROM covid19data_cleaned;

CREATE TABLE deaths AS SELECT
	location, date,
	# DEATHS
	total_deaths,
	new_deaths,
	new_deaths_smoothed,
	total_deaths_per_million,
	new_deaths_per_million,
	new_deaths_smoothed_per_million,
	excess_mortality
FROM covid19data_cleaned;

CREATE TABLE stringency AS SELECT 
	location, date,
	stringency_index
FROM covid19data_cleaned;

CREATE TABLE vaccinations AS
SELECT * FROM country_vaccinations_cleaned
NATURAL JOIN 
(
SELECT location, date, new_vaccinations, new_vaccinations_smoothed, new_vaccinations_smoothed_per_million FROM covid19data_cleaned
) t;
#ON country_vaccinations_cleaned.location = t.location AND country_vaccinations_cleaned.date = t.date;