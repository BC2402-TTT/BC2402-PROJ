#########################################################
####### 1.	What is the total population in Asia? #######
#########################################################
SELECT sum(population) as total_population_in_asia
FROM (SELECT population 
	  FROM locations 
      WHERE continent = 'Asia'
      GROUP BY location) AS subquery;
      
###############################################################################
####### 2.	What is the total population among the ten ASEAN countries? #######
###############################################################################
SELECT SUM(population) AS total_asean_population_top_ten
FROM (SELECT population
	  FROM locations
      WHERE location IN ('Brunei', 'Cambodia', 'Indonesia', 'Laos', 'Malaysia', 'Myanmar', 'Philippines', 'Singapore', 'Thailand', 'Vietnam') 
      GROUP BY location 
      ORDER BY population) AS subquery;


#########################################################################
####### 3.	Generate a list of unique data sources (source_name). #######
#########################################################################
SELECT DISTINCT source_name 
FROM sources 
ORDER BY source_name;

##################################################################################################################################################
####### 4.	Specific to Singapore, display the daily total_vaccinations starting (inclusive) March-1 2021 through (inclusive) May-31 2021. #######
##################################################################################################################################################
# We used daily vaccinations instead of raw daily vaccinations as it is cleaned and validated, so it is likely to be more accurate.
SELECT date, daily_vaccinations AS daily_total_vaccinations 
FROM vaccinations 
WHERE location = 'Singapore' AND date BETWEEN '2021-03-01' AND '2021-05-31';









##########################################################################################################################################################################################
####### 9.	Vaccination Drivers. Specific to Germany, based on each daily new case, ######################################################################################################
############display the total vaccinations of each available vaccines after 20 days, 30 days, and 40 days. ###############################################################################
##########################################################################################################################################################################################
SELECT DISTINCT c.date, c.new_cases, c.vaccine,
d20.D20_avail_vaccine-c.total_vaccinations AS D20_vaccine, 
d30.D30_avail_vaccine-c.total_vaccinations AS D30_vaccine
, d40.D40_avail_vaccine-c.total_vaccinations AS D40_vaccine
FROM
(SELECT DISTINCT cd.date, 
cd.new_cases, cm.vaccine, cm.total_vaccinations, 
date_add(cd.date, INTERVAL 20 DAY) AS DAY20, 
date_add(cd.date, INTERVAL 30 DAY) AS DAY30, 
date_add(cd.date, INTERVAL 40 DAY) AS DAY40
FROM cases cd
JOIN country_vaccinations_28oct.country_vaccinations_by_manufacturer_sem6_grp2 cm ON cm.date = cd.date
WHERE cd.location = 'Germany'
) c
LEFT JOIN(SELECT DATE, vaccine, total_vaccinations AS D20_avail_vaccine 
			FROM country_vaccinations_28oct.country_vaccinations_by_manufacturer_sem6_grp2 
            WHERE location = 'Germany') d20 ON d20.date = c.DAY20 AND d20.vaccine = c.vaccine
LEFT JOIN(SELECT DATE, vaccine, total_vaccinations AS D30_avail_vaccine 
			FROM country_vaccinations_28oct.country_vaccinations_by_manufacturer_sem6_grp2 
            WHERE location = 'Germany') d30 ON d30.date = c.DAY30 AND d30.vaccine = c.vaccine
LEFT JOIN(SELECT DATE, vaccine, total_vaccinations AS D40_avail_vaccine 
			FROM country_vaccinations_28oct.country_vaccinations_by_manufacturer_sem6_grp2 
            WHERE location = 'Germany') d40 ON d40.date = c.DAY40 AND d40.vaccine = c.vaccine;
