# Create dimension table for country statistics
CREATE TABLE locations AS SELECT 
	location, iso_code, continent, population, population_density, median_age, aged_65_older, aged_70_older
    , gdp_per_capita, extreme_poverty, cardiovasc_death_rate, diabetes_prevalence, female_smokers, male_smokers
    , handwashing_facilities, hospital_beds_per_thousand, life_expectancy, human_development_index
FROM covid19data_cleaned
GROUP BY location;

# Drop related data from covid19 table
ALTER TABLE covid19data_cleaned
	DROP iso_code, 
    DROP continent,
    DROP /*tests_units,*/ population, 
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
SELECT * FROM covid19data_cleaned;

# Drop related column from country_vaccinations and rename country column to location
ALTER TABLE country_vaccinations_cleaned
	DROP iso_code,
    RENAME COLUMN country TO location;

SELECT * FROM locations;

####################################################################################

SELECT 
	#COUNT(DISTINCT iso_code)							 as iso_code,
    #COUNT(DISTINCT continent) 							 as continent,
	location,
    COUNT(DISTINCT date) 								 as date,
	COUNT(DISTINCT total_cases) 						 as total_cases,
    COUNT(DISTINCT new_cases)							 as new_cases,
    COUNT(DISTINCT new_cases_smoothed)					 as new_cases_smoothed,
    COUNT(DISTINCT total_deaths)						 as total_deaths,
    COUNT(DISTINCT new_deaths) 							 as new_deaths,
	COUNT(DISTINCT new_deaths_smoothed)					 as new_deaths_smoothed,
    COUNT(DISTINCT total_cases_per_million) 			 as total_cases_per_million,
	COUNT(DISTINCT new_cases_per_million) 				 as new_cases_per_million,
    COUNT(DISTINCT new_cases_smoothed_per_million)		 as new_cases_smoothed_per_million,
    COUNT(DISTINCT total_deaths_per_million)			 as total_deaths_per_million,
    COUNT(DISTINCT new_deaths_per_million)				 as new_deaths_per_million,
    COUNT(DISTINCT new_deaths_smoothed_per_million) 	 as new_deaths_smoothed_per_million,
	COUNT(DISTINCT reproduction_rate) 					 as reproduction_rate,
    COUNT(DISTINCT icu_patients) 						 as icu_patients,
	COUNT(DISTINCT icu_patients_per_million) 			 as icu_patients_per_million,
    COUNT(DISTINCT hosp_patients)						 as hosp_patients,
    COUNT(DISTINCT hosp_patients_per_million)			 as hosp_patients_per_million,
    COUNT(DISTINCT weekly_icu_admissions)				 as weekly_icu_admissions,
    COUNT(DISTINCT weekly_icu_admissions_per_million)	 as weekly_icu_admissions_per_million,
	COUNT(DISTINCT weekly_hosp_admissions)				 as weekly_hosp_admissions,
    COUNT(DISTINCT weekly_hosp_admissions_per_million)	 as weekly_hosp_admissions_per_million,
	COUNT(DISTINCT new_tests) 							 as new_tests,
    COUNT(DISTINCT total_tests)							 as total_tests,
    COUNT(DISTINCT total_tests_per_thousand)			 as total_tests_per_thousand,
    COUNT(DISTINCT new_tests_per_thousand)	 			 as new_tests_per_thousand,
    COUNT(DISTINCT new_tests_smoothed)					 as new_tests_smoothed,
    COUNT(DISTINCT new_tests_smoothed_per_thousand)		 as new_tests_smoothed_per_thousand,
	COUNT(DISTINCT positive_rate)						 as positive_rate,
    COUNT(DISTINCT tests_per_case)						 as tests_per_case,
    COUNT(DISTINCT tests_units)							 as tests_units,
    COUNT(DISTINCT total_vaccinations)					 as total_vaccinations,
    COUNT(DISTINCT people_vaccinated)					 as people_vaccinated,
    COUNT(DISTINCT people_fully_vaccinated)				 as people_fully_vaccinated,
	COUNT(DISTINCT new_vaccinations)					 as new_vaccinations,
    COUNT(DISTINCT new_vaccinations_smoothed) 			 as new_vaccinations_smoothed,
    COUNT(DISTINCT total_vaccinations_per_hundred)		 as total_vaccinations_per_hundred,
    COUNT(DISTINCT people_vaccinated_per_hundred)		 as people_vaccinated_per_hundred,
	COUNT(DISTINCT people_fully_vaccinated_per_hundred)  as people_fully_vaccinated_per_hundred,
   COUNT(DISTINCT new_vaccinations_smoothed_per_million) as new_vaccinations_smoothed_per_million,
    COUNT(DISTINCT stringency_index) 					 as stringency_index,
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
    COUNT(DISTINCT excess_mortality)					 as excess_mortality
FROM covid19data_cleaned
GROUP BY location;

;SELECT 
	location,
    COUNT(DISTINCT date),
    COUNT(DISTINCT source_name),
    COUNT(DISTINCT source_website)
FROM country_vaccinations
GROUP BY location;