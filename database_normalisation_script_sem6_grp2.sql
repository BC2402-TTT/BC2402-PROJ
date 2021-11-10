################################################################################################
#####  SEM6 GRP2  ##############################################################################
################################################################################################
### This script can be run on the original database dump to generate our own implementation of
### the database.
### During script development, some checks using SELECT statements were done to verify our steps. 
### These steps have been commented out using '###' to prevent clogging of the Result Grid,
### but can be uncommented at any time for re-verification if needed.

################################################################################################
#####  CLEANING: covid19data  ##################################################################
################################################################################################
###SELECT COLUMN_NAME, DATA_TYPE from INFORMATION_SCHEMA.COLUMNS
###WHERE table_name = "covid19data";

# 1. Create a new table called "covid19data_cleaned"
# 2. Set all empty strings to NULL
CREATE TABLE covid19data_cleaned AS SELECT 
	NULLIF(iso_code,							'') as iso_code,
    NULLIF(continent, 							'') as continent,
	NULLIF(location, 							'') as location,
    NULLIF(date, 								'') as date,
	NULLIF(total_cases, 						'') as total_cases,
    NULLIF(new_cases,							'') as new_cases,
    NULLIF(new_cases_smoothed,					'') as new_cases_smoothed,
    NULLIF(total_deaths,						'') as total_deaths,
    NULLIF(new_deaths, 							'') as new_deaths,
	NULLIF(new_deaths_smoothed,					'') as new_deaths_smoothed,
    NULLIF(total_cases_per_million, 			'') as total_cases_per_million,
	NULLIF(new_cases_per_million, 				'') as new_cases_per_million,
    NULLIF(new_cases_smoothed_per_million,		'') as new_cases_smoothed_per_million,
    NULLIF(total_deaths_per_million,			'') as total_deaths_per_million,
    NULLIF(new_deaths_per_million,				'') as new_deaths_per_million,
    NULLIF(new_deaths_smoothed_per_million, 	'') as new_deaths_smoothed_per_million,
	NULLIF(reproduction_rate, 					'') as reproduction_rate,
    NULLIF(icu_patients, 						'') as icu_patients,
	NULLIF(icu_patients_per_million, 			'') as icu_patients_per_million,
    NULLIF(hosp_patients,						'') as hosp_patients,
    NULLIF(hosp_patients_per_million,			'') as hosp_patients_per_million,
    NULLIF(weekly_icu_admissions,				'') as weekly_icu_admissions,
    NULLIF(weekly_icu_admissions_per_million,	'') as weekly_icu_admissions_per_million,
	NULLIF(weekly_hosp_admissions,				'') as weekly_hosp_admissions,
    NULLIF(weekly_hosp_admissions_per_million, 	'') as weekly_hosp_admissions_per_million,
	NULLIF(new_tests, 							'') as new_tests,
    NULLIF(total_tests,							'') as total_tests,
    NULLIF(total_tests_per_thousand,			'') as total_tests_per_thousand,
    NULLIF(new_tests_per_thousand, 				'') as new_tests_per_thousand,
    NULLIF(new_tests_smoothed,					'') as new_tests_smoothed,
    NULLIF(new_tests_smoothed_per_thousand,		'') as new_tests_smoothed_per_thousand,
	NULLIF(positive_rate, 						'') as positive_rate,
    NULLIF(tests_per_case,						'') as tests_per_case,
    NULLIF(tests_units,							'') as tests_units,
    NULLIF(total_vaccinations, 					'') as total_vaccinations,
    NULLIF(people_vaccinated,					'') as people_vaccinated,
    NULLIF(people_fully_vaccinated,				'') as people_fully_vaccinated,
	NULLIF(new_vaccinations,					'') as new_vaccinations,
    NULLIF(new_vaccinations_smoothed, 			'') as new_vaccinations_smoothed,
    NULLIF(total_vaccinations_per_hundred,		'') as total_vaccinations_per_hundred,
    NULLIF(people_vaccinated_per_hundred,		'') as people_vaccinated_per_hundred,
	NULLIF(people_fully_vaccinated_per_hundred,	'') as people_fully_vaccinated_per_hundred,
   NULLIF(new_vaccinations_smoothed_per_million,'') as new_vaccinations_smoothed_per_million,
    NULLIF(stringency_index, 					'') as stringency_index,
    NULLIF(population,							'') as population,
    NULLIF(population_density,					'') as population_density,
	NULLIF(median_age, 							'') as median_age,
    NULLIF(aged_65_older,						'') as aged_65_older,
    NULLIF(aged_70_older,						'') as aged_70_older,
	NULLIF(gdp_per_capita, 						'') as gdp_per_capita,
    NULLIF(extreme_poverty,						'') as extreme_poverty,
    NULLIF(cardiovasc_death_rate,				'') as cardiovasc_death_rate,
	NULLIF(diabetes_prevalence, 				'') as diabetes_prevalence,
    NULLIF(female_smokers,						'') as female_smokers,
    NULLIF(male_smokers,						'') as male_smokers,
	NULLIF(handwashing_facilities, 				'') as handwashing_facilities,
    NULLIF(hospital_beds_per_thousand,			'') as hospital_beds_per_thousand,
    NULLIF(life_expectancy,						'') as life_expectancy,
	NULLIF(human_development_index, 			'') as human_development_index,
    NULLIF(excess_mortality,					'') as excess_mortality
FROM covid19data;

# 3. Change the data types
ALTER TABLE covid19data_cleaned
	#iso_code	-->										TEXT
    #continent	--> 									TEXT
    #location	--> 									TEXT
	MODIFY COLUMN date									DATE,
    MODIFY COLUMN total_cases							BIGINT,
	MODIFY COLUMN new_cases								INT,
    MODIFY COLUMN new_cases_smoothed					DECIMAL(12, 3),
    MODIFY COLUMN total_deaths							INT,
    MODIFY COLUMN new_deaths							INT,
    MODIFY COLUMN new_deaths_smoothed					DECIMAL(12,3),
    MODIFY COLUMN total_cases_per_million				DECIMAL(12,3),
    MODIFY COLUMN new_cases_per_million					DECIMAL(12,3),
    MODIFY COLUMN new_cases_smoothed_per_million		DECIMAL(12,3),
    MODIFY COLUMN total_deaths_per_million				DECIMAL(12,3),
    MODIFY COLUMN new_deaths_per_million				DECIMAL(12,3),
    MODIFY COLUMN new_deaths_smoothed_per_million		DECIMAL(12,3),
	MODIFY COLUMN reproduction_rate						DECIMAL(12,2),
    MODIFY COLUMN icu_patients	 						INT,
	MODIFY COLUMN icu_patients_per_million 				DECIMAL(12,3),
    MODIFY COLUMN hosp_patients							INT,
    MODIFY COLUMN hosp_patients_per_million				DECIMAL(12,3),
    MODIFY COLUMN weekly_icu_admissions					DECIMAL(12,3),
    MODIFY COLUMN weekly_icu_admissions_per_million 	DECIMAL(12,3),
	MODIFY COLUMN weekly_hosp_admissions				DECIMAL(12,3),
    MODIFY COLUMN weekly_hosp_admissions_per_million 	DECIMAL(12,3),
	MODIFY COLUMN new_tests								INT,
    MODIFY COLUMN total_tests							INT,
    MODIFY COLUMN total_tests_per_thousand				DECIMAL(12,3),
    MODIFY COLUMN new_tests_per_thousand				DECIMAL(12,3),
    MODIFY COLUMN new_tests_smoothed					DECIMAL(12,3),
    MODIFY COLUMN new_tests_smoothed_per_thousand		DECIMAL(12,3),
	MODIFY COLUMN positive_rate							DECIMAL(12,3),
    MODIFY COLUMN tests_per_case						DECIMAL(12,1),
    MODIFY COLUMN tests_units							TEXT,
    MODIFY COLUMN total_vaccinations 					BIGINT,
    MODIFY COLUMN people_vaccinated						BIGINT,
    MODIFY COLUMN people_fully_vaccinated				BIGINT,
	MODIFY COLUMN new_vaccinations						INT,
    MODIFY COLUMN new_vaccinations_smoothed				INT,
    MODIFY COLUMN total_vaccinations_per_hundred		DECIMAL(12,2),
    MODIFY COLUMN people_vaccinated_per_hundred			DECIMAL(12,2),
    MODIFY COLUMN people_fully_vaccinated_per_hundred 	DECIMAL(12,2),
    MODIFY COLUMN new_vaccinations_smoothed_per_million	INT,
    MODIFY COLUMN stringency_index						DECIMAL(12,2),
    MODIFY COLUMN population							BIGINT,
    MODIFY COLUMN population_density					DECIMAL(12,3),
	MODIFY COLUMN median_age							DECIMAL(12,1),
    MODIFY COLUMN aged_65_older							DECIMAL(12,3),
    MODIFY COLUMN aged_70_older							DECIMAL(12,3),
	MODIFY COLUMN gdp_per_capita						DECIMAL(12,3),
    MODIFY COLUMN extreme_poverty						DECIMAL(12,1),
    MODIFY COLUMN cardiovasc_death_rate					DECIMAL(12,3),
	MODIFY COLUMN diabetes_prevalence					DECIMAL(12,2),
    MODIFY COLUMN female_smokers						DECIMAL(12,3),
    MODIFY COLUMN male_smokers							DECIMAL(12,3),
	MODIFY COLUMN handwashing_facilities				DECIMAL(12,3),
    MODIFY COLUMN hospital_beds_per_thousand			DECIMAL(12,3),
    MODIFY COLUMN life_expectancy						DECIMAL(12,2),
	MODIFY COLUMN human_development_index				DECIMAL(12,3),
    MODIFY COLUMN excess_mortality						DECIMAL(12,2);

# 4. Verify that the datatypes have been changed
###SELECT COLUMN_NAME, DATA_TYPE from INFORMATION_SCHEMA.COLUMNS
###WHERE table_name = "covid19data_cleaned";

# 5. Verify that the data values remain unchanged
###SELECT * FROM covid19data_cleaned;

################################################################################################
#####  CLEANING: country_vaccinations  #########################################################
################################################################################################
###SELECT COLUMN_NAME, DATA_TYPE from INFORMATION_SCHEMA.COLUMNS
###WHERE table_name = "country_vaccinations";

# 1. Create a new table called "country_vaccinations_cleaned"
CREATE TABLE country_vaccinations_cleaned AS SELECT * FROM country_vaccinations;

# 2. Change the formatting of the DATE column to proper mySQL format. 
# We need to do this, else mySQL cannot modify the column to be DATE datatype in the next step
# Note: need to set SAFE_UPDATES flag to off because we are not specifying a primary key in the WHERE clause -
# we don't need to, because every row has to be updated anyway.
# We set the flag back on afterward
SET SQL_SAFE_UPDATES = 0;
UPDATE country_vaccinations_cleaned SET date = STR_TO_DATE(date, '%c/%e/%Y');
SET SQL_SAFE_UPDATES = 1;

# 3. Change the data types
ALTER TABLE country_vaccinations_cleaned
	#country	-->										TEXT
    #iso_code	--> 									TEXT
	MODIFY COLUMN date									DATE,
    MODIFY COLUMN total_vaccinations					BIGINT,
	MODIFY COLUMN people_vaccinated						BIGINT,
    MODIFY COLUMN people_fully_vaccinated				BIGINT,
    MODIFY COLUMN daily_vaccinations_raw				INT,
    MODIFY COLUMN daily_vaccinations					INT,
    MODIFY COLUMN total_vaccinations_per_hundred		DECIMAL(12,3),
    MODIFY COLUMN people_vaccinated_per_hundred			DECIMAL(12,3),
    MODIFY COLUMN people_fully_vaccinated_per_hundred	DECIMAL(12,3),
    MODIFY COLUMN daily_vaccinations_per_million		INT,
    MODIFY COLUMN vaccines								TEXT,
	MODIFY COLUMN source_name							TEXT,
    MODIFY COLUMN source_website						TEXT;
    
# 4. Verify that the datatypes have been changed
###SELECT COLUMN_NAME, DATA_TYPE from INFORMATION_SCHEMA.COLUMNS
###WHERE table_name = "country_vaccinations_cleaned";

# 5. Verify that the data values remain unchanged
###SELECT * FROM country_vaccinations_cleaned;

################################################################################################
#####  CLEANING: country_vaccinations_by_manufacturer  #########################################
################################################################################################
###SELECT COLUMN_NAME, DATA_TYPE from INFORMATION_SCHEMA.COLUMNS
###WHERE table_name = "country_vaccinations_by_manufacturer";

# 1. Create a new table called "country_vaccinations_cleaned"
CREATE TABLE country_vaccinations_by_manufacturer_cleaned AS SELECT * FROM country_vaccinations_by_manufacturer;

# 2. The formatting of date here is correct (unlike country_vaccinations)
# Hence, we don't need to transform anything.

# 3. Change the data types
ALTER TABLE country_vaccinations_by_manufacturer_cleaned
	MODIFY COLUMN location								TEXT,
    MODIFY COLUMN date									DATE,
	MODIFY COLUMN vaccine								TEXT,
    MODIFY COLUMN total_vaccinations					BIGINT;
    
# 4. Verify that the datatypes have been changed
###SELECT COLUMN_NAME, DATA_TYPE from INFORMATION_SCHEMA.COLUMNS
###WHERE table_name = "country_vaccinations_by_manufacturer_cleaned";

# 5. Verify that the data values remain unchanged
###SELECT * FROM country_vaccinations_by_manufacturer_cleaned;

################################################################################################
#####  NORMALISING: countries-vaccines  ########################################################
################################################################################################
# 0. Verify that each country only has one corresponding multi-valued vaccine entry
###SELECT COUNT(DISTINCT vaccines) as numVacs, country FROM country_vaccinations_cleaned
###GROUP BY country
###ORDER BY numVacs DESC;
# the highest numVacs is 1. Hence, this assumption is verified.

# 1. Determine the maximum number of vaccines a single country has in the vaccines column.
###SELECT country, (length(vaccines) - length(REPLACE(vaccines, ';', ''))+1) as maxVaccines FROM country_vaccinations
###GROUP BY country
###ORDER BY maxVaccines DESC;
# the maximum is 6 (by Hungary and Libya)

# 2. Splice the vaccines column into 6 different columns and save it as a view.
CREATE VIEW spliced AS SELECT
	country,
    SUBSTRING_INDEX(vaccines, ';', 1) AS vaccine1,
    SUBSTRING_INDEX(SUBSTRING_INDEX(vaccines, '; ', 2), '; ', -1) AS vaccine2,
    SUBSTRING_INDEX(SUBSTRING_INDEX(vaccines, '; ', 3), '; ', -1) AS vaccine3,
    SUBSTRING_INDEX(SUBSTRING_INDEX(vaccines, '; ', 4), '; ', -1) AS vaccine4,
	SUBSTRING_INDEX(SUBSTRING_INDEX(vaccines, '; ', 5), '; ', -1) AS vaccine5,
	SUBSTRING_INDEX(SUBSTRING_INDEX(vaccines, '; ', 6), '; ', -1) AS vaccine6
FROM country_vaccinations
GROUP BY country;

# 3. Union all the splices together into a new intersection table.
CREATE TABLE locations_vaccines AS
      SELECT country as location, vaccine1 as vaccine FROM spliced
UNION SELECT country as location, vaccine2 as vaccine FROM spliced
UNION SELECT country as location, vaccine3 as vaccine FROM spliced
UNION SELECT country as location, vaccine4 as vaccine FROM spliced
UNION SELECT country as location, vaccine5 as vaccine FROM spliced
UNION SELECT country as location, vaccine6 as vaccine FROM spliced
GROUP BY location, vaccine1
ORDER BY location ASC;
DROP VIEW spliced;

# 4. Drop the vaccines column from the original
ALTER TABLE country_vaccinations_cleaned
	DROP vaccines;

# 5. Create the vaccine table
CREATE TABLE vaccine AS
	SELECT vaccine FROM locations_vaccines
    GROUP BY vaccine
    ORDER BY vaccine ASC;
    
################################################################################################
#####  NORMALISING: location attributes, iso_code  #############################################
################################################################################################
# 0. Verify which columns contain information about the location.
###SELECT 
###	#COUNT(DISTINCT iso_code)							 as iso_code,
###    #COUNT(DISTINCT continent) 							 as continent,
###	location,
###		COUNT(DISTINCT date) 								 as date,
###		COUNT(DISTINCT total_cases) 						 as total_cases,
###    	COUNT(DISTINCT new_cases)							 as new_cases,
###    	COUNT(DISTINCT new_cases_smoothed)					 as new_cases_smoothed,
###    	COUNT(DISTINCT total_deaths)						 as total_deaths,
###    	COUNT(DISTINCT new_deaths) 							 as new_deaths,
###		COUNT(DISTINCT new_deaths_smoothed)					 as new_deaths_smoothed,
### 	COUNT(DISTINCT total_cases_per_million) 			 as total_cases_per_million,
###		COUNT(DISTINCT new_cases_per_million) 				 as new_cases_per_million,
### 	COUNT(DISTINCT new_cases_smoothed_per_million)		 as new_cases_smoothed_per_million,
###    	COUNT(DISTINCT total_deaths_per_million)			 as total_deaths_per_million,
###    	COUNT(DISTINCT new_deaths_per_million)				 as new_deaths_per_million,
###    	COUNT(DISTINCT new_deaths_smoothed_per_million) 	 as new_deaths_smoothed_per_million,
###		COUNT(DISTINCT reproduction_rate) 					 as reproduction_rate,
###    	COUNT(DISTINCT icu_patients) 						 as icu_patients,
###		COUNT(DISTINCT icu_patients_per_million) 			 as icu_patients_per_million,
###    	COUNT(DISTINCT hosp_patients)						 as hosp_patients,
###    	COUNT(DISTINCT hosp_patients_per_million)			 as hosp_patients_per_million,
###    	COUNT(DISTINCT weekly_icu_admissions)				 as weekly_icu_admissions,
###    	COUNT(DISTINCT weekly_icu_admissions_per_million)	 as weekly_icu_admissions_per_million,
###		COUNT(DISTINCT weekly_hosp_admissions)				 as weekly_hosp_admissions,
###    	COUNT(DISTINCT weekly_hosp_admissions_per_million)	 as weekly_hosp_admissions_per_million,
###		COUNT(DISTINCT new_tests) 							 as new_tests,
###    	COUNT(DISTINCT total_tests)							 as total_tests,
###    	COUNT(DISTINCT total_tests_per_thousand)			 as total_tests_per_thousand,
###    	COUNT(DISTINCT new_tests_per_thousand)	 			 as new_tests_per_thousand,
###    	COUNT(DISTINCT new_tests_smoothed)					 as new_tests_smoothed,
###    	COUNT(DISTINCT new_tests_smoothed_per_thousand)		 as new_tests_smoothed_per_thousand,
###		COUNT(DISTINCT positive_rate)						 as positive_rate,
###    	COUNT(DISTINCT tests_per_case)						 as tests_per_case,
###    	COUNT(DISTINCT tests_units)							 as tests_units,
###    	COUNT(DISTINCT total_vaccinations)					 as total_vaccinations,
###    	COUNT(DISTINCT people_vaccinated)					 as people_vaccinated,
###    	COUNT(DISTINCT people_fully_vaccinated)				 as people_fully_vaccinated,
###		COUNT(DISTINCT new_vaccinations)					 as new_vaccinations,
###    	COUNT(DISTINCT new_vaccinations_smoothed) 			 as new_vaccinations_smoothed,
###    	COUNT(DISTINCT total_vaccinations_per_hundred)		 as total_vaccinations_per_hundred,
###    	COUNT(DISTINCT people_vaccinated_per_hundred)		 as people_vaccinated_per_hundred,
###		COUNT(DISTINCT people_fully_vaccinated_per_hundred)  as people_fully_vaccinated_per_hundred,
###   	COUNT(DISTINCT new_vaccinations_smoothed_per_million) as new_vaccinations_smoothed_per_million,
###    	COUNT(DISTINCT stringency_index) 					 as stringency_index,
    #COUNT(DISTINCT population)							 as population,
    #COUNT(DISTINCT population_density)					 as population_density,
	#COUNT(DISTINCT median_age)							 as median_age,
    #COUNT(DISTINCT aged_65_older)						 as aged_65_older,
    #COUNT(DISTINCT aged_70_older)						 as aged_70_older,
	#COUNT(DISTINCT gdp_per_capita) 					 as gdp_per_capita,
    #COUNT(DISTINCT extreme_poverty)					 as extreme_poverty,
    #COUNT(DISTINCT cardiovasc_death_rate)				 as cardiovasc_death_rate,
	#COUNT(DISTINCT diabetes_prevalence) 				 as diabetes_prevalence,
    #COUNT(DISTINCT female_smokers)						 as female_smokers,
    #COUNT(DISTINCT male_smokers)						 as male_smokers,
	#COUNT(DISTINCT handwashing_facilities) 			 as handwashing_facilities,
    #COUNT(DISTINCT hospital_beds_per_thousand)			 as hospital_beds_per_thousand,
    #COUNT(DISTINCT life_expectancy)					 as life_expectancy,
	#COUNT(DISTINCT human_development_index) 			 as human_development_index,
###    COUNT(DISTINCT excess_mortality)					 as excess_mortality
###FROM covid19data_cleaned
###GROUP BY location;
# the attributes that only return 1 for COUNT DISTINCT are the information attributes.

# 1. Create locations table
CREATE TABLE locations AS SELECT 
	location, iso_code, continent, population, population_density, median_age, aged_65_older, aged_70_older
    , gdp_per_capita, extreme_poverty, cardiovasc_death_rate, diabetes_prevalence, female_smokers, male_smokers
    , handwashing_facilities, hospital_beds_per_thousand, life_expectancy, human_development_index
FROM covid19data_cleaned
GROUP BY location;

# 2. Drop related data from covid19 table
ALTER TABLE covid19data_cleaned
	DROP iso_code,
    DROP continent,
    DROP population, 
    DROP population_density, 
    DROP median_age, 
    DROP aged_65_older,
    DROP aged_70_older,
    DROP gdp_per_capita, 
    DROP extreme_poverty, 
    DROP cardiovasc_death_rate,
    DROP diabetes_prevalence, 
    DROP female_smokers,
    DROP male_smokers,
    DROP handwashing_facilities, 
    DROP hospital_beds_per_thousand, 
    DROP life_expectancy,
    DROP human_development_index;

# 3. Also deal with source_name and source_website to location attributes
###SELECT 
###    country,
###	COUNT(DISTINCT source_name)							 as source_name,
###    COUNT(DISTINCT source_website)						 as source_website
###FROM country_vaccinations_cleaned
###GROUP BY country; #217 rows. We must perform a left join

# 3.1. Rename country column to location
ALTER TABLE country_vaccinations_cleaned
    RENAME COLUMN country TO location;

# 3.2. Join sources with location to form new table
CREATE TABLE location2 AS SELECT 
	locations.location, iso_code, continent, population, population_density, median_age, aged_65_older, aged_70_older
    , gdp_per_capita, extreme_poverty, cardiovasc_death_rate, diabetes_prevalence, female_smokers, male_smokers
    , handwashing_facilities, hospital_beds_per_thousand, life_expectancy, human_development_index, source_name, source_website
FROM locations
LEFT JOIN
(
SELECT location, source_name, source_website FROM country_vaccinations_cleaned
GROUP BY location
) t ON locations.location = t.location;

# 3.3. Override current location table with new table
DROP TABLE locations;
ALTER TABLE location2
  RENAME TO location;

# 4. Create iso_code table
###SELECT location, iso_code FROM location; #213 rows
###SELECT location, iso_code FROM country_vaccinations_cleaned GROUP BY location; #217 rows
# locations has the full 230 iso_codes, while country_vaccinations only has 217. Hence we use locations

CREATE TABLE iso_code AS SELECT
location, iso_code FROM location;

# 5. Drop iso_code
ALTER TABLE location
	DROP iso_code;
ALTER TABLE country_vaccinations_cleaned
	DROP iso_code,
    DROP source_name,
    DROP source_website;

################################################################################################
#####  SPLITTING: tests, cases, hospitals, deaths, stringency, vaccinations  ###################
################################################################################################
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

################################################################################################
#####  CLEANING: delete null rows, drop original data  #########################################
################################################################################################
SET SQL_SAFE_UPDATES = 0;

# 1. Delete rows where all the non-primary keys are are null
DELETE FROM tests
WHERE	total_tests						is null or 0
	AND	new_tests						is null or 0
    AND total_tests_per_thousand	 	is null or 0
    AND new_tests_per_thousand			is null or 0
    AND new_tests_smoothed				is null or 0
    AND new_tests_smoothed_per_thousand	is null or 0
    AND positive_rate					is null or 0
    AND tests_per_case					is null or 0;
###SELECT * FROM tests;

DELETE FROM cases
WHERE	total_cases						is null or 0
    AND	new_cases						is null or 0
    AND total_cases_per_million			is null or 0
    AND new_cases_smoothed				is null or 0
    AND new_cases_per_million			is null or 0
    AND new_cases_smoothed_per_million	is null or 0
	AND	reproduction_rate				is null or 0;
###SELECT * FROM cases;

DELETE FROM hospitals
WHERE	icu_patients						is null or 0
	AND icu_patients_per_million			is null or 0
	AND	hosp_patients						is null or 0
    AND hosp_patients_per_million		 	is null or 0
    AND weekly_icu_admissions				is null or 0
    AND weekly_icu_admissions_per_million	is null or 0
    AND weekly_hosp_admissions				is null or 0
    AND weekly_hosp_admissions_per_million	is null or 0;
###SELECT * FROM hospitals;

DELETE FROM deaths
WHERE	total_deaths 					is null or 0
	AND new_deaths						is null or 0
	AND	new_deaths_smoothed				is null or 0
	AND	total_deaths_per_million		is null or 0
	AND	new_deaths_per_million			is null or 0
	AND	new_deaths_smoothed_per_million	is null or 0
	AND excess_mortality				is null or 0;
###SELECT * FROM deaths;

DELETE FROM stringency
WHERE	stringency_index				is null or 0;
###SELECT * FROM stringency;

SET SQL_SAFE_UPDATES = 1;

DROP TABLE covid19data;
DROP TABLE covid19data_cleaned;
DROP TABLE country_vaccinations;
DROP TABLE country_vaccinations_cleaned;
DROP TABLE country_vaccinations_by_manufacturer;

################################################################################################
#####  CLEANING: set primary and foreign key constraints  ######################################
################################################################################################
SET FOREIGN_KEY_CHECKS=0;

ALTER TABLE location
	MODIFY COLUMN location VARCHAR(255),
	ADD CONSTRAINT location_pk PRIMARY KEY (location);
    
ALTER TABLE vaccine
	MODIFY COLUMN vaccine VARCHAR(255),
	ADD CONSTRAINT vaccine_pk PRIMARY KEY (vaccine);


ALTER TABLE cases
	MODIFY COLUMN location VARCHAR(255),
	ADD CONSTRAINT cases_pk PRIMARY KEY (location, date),
    ADD CONSTRAINT cases_fk FOREIGN KEY(location) REFERENCES location(location) ON DELETE RESTRICT ON UPDATE CASCADE;

ALTER TABLE deaths
	MODIFY COLUMN location VARCHAR(255),
	ADD CONSTRAINT deaths_pk PRIMARY KEY (location, date),
    ADD CONSTRAINT deaths_fk FOREIGN KEY(location) REFERENCES location(location) ON DELETE RESTRICT ON UPDATE CASCADE;

ALTER TABLE hospitals
	MODIFY COLUMN location VARCHAR(255),
	ADD CONSTRAINT hospitals_pk PRIMARY KEY (location, date),
    ADD CONSTRAINT hospitals_fk FOREIGN KEY(location) REFERENCES location(location) ON DELETE RESTRICT ON UPDATE CASCADE;

ALTER TABLE iso_code
	MODIFY COLUMN location VARCHAR(255),
	ADD CONSTRAINT iso_code_pk PRIMARY KEY (location),
    ADD CONSTRAINT iso_code_fk FOREIGN KEY(location) REFERENCES location(location) ON DELETE RESTRICT ON UPDATE CASCADE;

ALTER TABLE stringency
	MODIFY COLUMN location VARCHAR(255),
	ADD CONSTRAINT stringency_pk PRIMARY KEY (location, date),
    ADD CONSTRAINT stringency_fk FOREIGN KEY(location) REFERENCES location(location) ON DELETE RESTRICT ON UPDATE CASCADE;

ALTER TABLE tests
	MODIFY COLUMN location VARCHAR(255),
	ADD CONSTRAINT tests_pk PRIMARY KEY (location, date),
    ADD CONSTRAINT tests_fk FOREIGN KEY(location) REFERENCES location(location) ON DELETE RESTRICT ON UPDATE CASCADE;

ALTER TABLE vaccinations
	MODIFY COLUMN location VARCHAR(255),
	ADD CONSTRAINT vaccinations_pk PRIMARY KEY (location, date),
    ADD CONSTRAINT vaccinations_fk FOREIGN KEY(location) REFERENCES location(location) ON DELETE RESTRICT ON UPDATE CASCADE;
    

ALTER TABLE locations_vaccines
	MODIFY COLUMN location VARCHAR(255),
    MODIFY COLUMN vaccine VARCHAR(255),
	ADD CONSTRAINT locations_vaccines_pk PRIMARY KEY (location, vaccine),
    ADD CONSTRAINT locations_vaccines_fk1 FOREIGN KEY(location) REFERENCES location(location) ON DELETE RESTRICT ON UPDATE CASCADE,
    ADD CONSTRAINT locations_vaccines_fk2 FOREIGN KEY(vaccine) REFERENCES vaccine(vaccine) ON DELETE RESTRICT ON UPDATE CASCADE;


ALTER TABLE country_vaccinations_by_manufacturer_cleaned
	MODIFY COLUMN location VARCHAR(255),
    MODIFY COLUMN vaccine VARCHAR(255),
	ADD CONSTRAINT country_vaccinations_by_manufacturer_cleaned_pk PRIMARY KEY (location, date, vaccine),
    ADD CONSTRAINT country_vaccinations_by_manufacturer_fk1 FOREIGN KEY(location) REFERENCES location(location) ON DELETE RESTRICT ON UPDATE CASCADE,
    ADD CONSTRAINT country_vaccinations_by_manufacturer_fk2 FOREIGN KEY(vaccine) REFERENCES vaccine(vaccine) ON DELETE RESTRICT ON UPDATE CASCADE;

SET FOREIGN_KEY_CHECKS=1;
