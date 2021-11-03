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
# From now onwards, we will use daily_vaccinations.
SELECT date, daily_vaccinations AS daily_total_vaccinations 
FROM vaccinations 
WHERE location = 'Singapore' AND date BETWEEN '2021-03-01' AND '2021-05-31';


##################################################################################
####### 5.	When is the first batch of vaccinations recorded in Singapore? #######
##################################################################################
# total_vaccinations:		the total number of COVID-19 vaccination doses administered
# daily_vaccinations:		for a certain data entry, the number of vaccination for that date/country
# 1/11/2021 has 3400 total_vaccinations, but 0 under daily_vaccinations
# 1/12/2021 has 6200 total_vaccinations, but 2800 under daily_vaccinations
# It is reasonable to assume that total_vaccinations for today is calculated by taking the 
# total_vaccinations of yesterday plus the daily_vaccinations of today, i.e.
# total_vaccinations_today = total_vaccinations_yesterday + daily_vaccinations_today.
# Therefore, the numbers for 1/12/2021 makes sense, since
# 6200 = 3400 + 2800
# We cannot do the same confirmation for 1/11/2021, since there is missing data for 1/10/2021 and earlier
# Hence, data in 1/12/2021 is more reliable.
SELECT MIN(date) as Q5Answer
FROM vaccinations 
WHERE location = 'Singapore'
AND daily_vaccinations > 0;


#################################################################################################################################
####### 6.	Based on the date identified in (5), specific to Singapore, compute the total number of new cases thereafter. #######
# For instance, if the date identified in (5) is Jan-1 2021, the total number of new cases will be the sum of new cases 
# starting from (inclusive) Jan-1 to the last date in the dataset.
################################################################################################################################# 
# total_cases:		total confirmed cases of COVID-19
SELECT SUM(new_cases) as Q6Answer
FROM cases
WHERE location = 'Singapore'
AND date >= 
(
	SELECT MIN(date) as date
	FROM vaccinations 
	WHERE location = 'Singapore'
	AND daily_vaccinations > 0
);

#########################################################################################################
####### 7.	Compute the total number of new cases in Singapore before the date identified in (5). #######
# For instance, if the date identified in (5) is Jan-1 2021 and the first date recorded (in Singapore) 
# in the dataset is Feb-1 2020, the total number of new cases will be the sum of new cases starting 
# from (inclusive) Feb-1 2020 through (inclusive) Dec-31 2020.
#########################################################################################################
SELECT SUM(new_cases) AS new_cases
FROM cases
WHERE location = 'Singapore' AND DATE <= (
	SELECT MIN(date)
	FROM vaccinations
	WHERE location = 'Singapore'
	AND daily_vaccinations>0);


####################################################################################################################################################################################################################################################################
####### 8.	Herd immunity estimation. On a daily basis, specific to Germany, calculate the percentage of new cases (i.e., percentage of new cases = new cases / populations) and total vaccinations on each available vaccine in relation to its population. #######
####################################################################################################################################################################################################################################################################
SELECT date, vaccine, new_cases/population * 100 as 'Percentage of New Cases / %', total_vaccinations/population * 100 as 'Percentage of Total Vaccinations / %'
FROM
cases NATURAL JOIN country_vaccinations_by_manufacturer_sem6_grp2 NATURAL JOIN locations
WHERE location = 'Germany'
GROUP BY date, vaccine;


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


##############################################################################################################################
####### 10.	Vaccination Effects. Specific to Germany, on a daily basis, ##################################################
#######		based on the total number of accumulated vaccinations (sum of total_vaccinations of each vaccine in a day),### 
#######		generate the daily new cases after 21 days, 60 days, and 120 days. ###########################################
##############################################################################################################################


CREATE VIEW q10 AS
SELECT date , sum(total_vaccinations) AS total
FROM country_vaccinations_28oct.country_vaccinations_by_manufacturer_sem6_grp2 cm
WHERE location = "Germany"
GROUP BY date
ORDER BY date;

CREATE VIEW q10_1 AS 
SELECT *, date_add(q10.date, INTERVAL 21 day) AS d21, date_add(q10.date, INTERVAL 60 day) AS d60, date_add(q10.date, INTERVAL 120 day) AS d120
FROM q10;

CREATE VIEW new1 AS 
SELECT date, new_cases AS day21
FROM cases
WHERE location = "Germany";

CREATE VIEW new2 as 
SELECT date, new_cases as day60
FROM cases
WHERE location = "Germany";

CREATE VIEW new3 as 
SELECT date, new_cases AS day120
FROM cases
WHERE location = "Germany";

SELECT q10_1.date, total AS sum_of_total_vaccinations, day21 AS daily_new_cases_after21days, day60 AS daily_new_cases_after60days, day120 AS daily_new_cases_after120days
FROM q10_1 
LEFT JOIN new1 ON q10_1.d21 = new1.date 
LEFT JOIN new2 ON q10_1.d60 = new2.date
LEFT JOIN new3 ON q10_1.d120 = new3.date;


