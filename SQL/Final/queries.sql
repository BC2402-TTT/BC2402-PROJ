#########################################################
####### 1.	What is the total population in Asia? #######
#########################################################
# The normalised "locations" table contains the population count for each country.
# We group the table by continents, then filter the table to only rows where the continent is 'Asia',
# this returns a table of all the Asian countries.
# Then we apply an aggregate SUM() function on the population column to obtain a single value response.
SELECT SUM(population)
FROM locations
GROUP BY continent
HAVING continent = 'Asia';


###############################################################################
####### 2.	What is the total population among the ten ASEAN countries? #######
###############################################################################
# The normalised "locations" table contains the population count for each country.
# We then sum the populations of rows that are in ASEAN.
SELECT SUM(population)
FROM locations
WHERE location IN ('Brunei', 'Cambodia', 'Indonesia', 'Laos', 'Malaysia', 'Myanmar', 'Philippines', 'Singapore', 'Thailand', 'Vietnam');


#########################################################################
####### 3.	Generate a list of unique data sources (source_name). #######
#########################################################################
# Using the source_name column as instructed in the question, we obtain 91 rows.
# However, this may not be correct method if we want to generate the list of UNIQUE data sources,
# because multiple countries list "Ministry of Health" as their source_name,
# but these Ministry of Health(s) are for their respective countries and should hence be considered different data sources.
# Examples of countries with MOH: Argentina, Austria, Uganda, Zimbabwe, ...
# By selecting source_website as opposed to source_name, i.e.
##	SELECT DISTINCT(source_name) as unique_data_sources
##	FROM sources
##	ORDER BY unique_data_sources;	
# We get 147 rows instead of 91.
SELECT DISTINCT(source_name) as unique_data_sources
FROM sources
ORDER BY unique_data_sources;


###############################################################################
####### 4.	Specific to Singapore, display the daily total_vaccinations #######
#######	starting (inclusive) March-1 2021 through (inclusive) May-31 2021.   ##
###############################################################################
# We used daily vaccinations instead of raw daily vaccinations as it is cleaned and validated, so it is likely to be more accurate.
# From now onwards, we will use daily_vaccinations.
SELECT date, daily_vaccinations AS daily_total_vaccinations 
FROM vaccinations 
WHERE location = 'Singapore' AND date BETWEEN '2021-03-01' AND '2021-05-31'
ORDER BY date;


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
SELECT MIN(date) as first_batch_of_vaccinations
FROM vaccinations 
WHERE location = 'Singapore'
AND daily_vaccinations > 0;


#################################################################################################################################
####### 6.	Based on the date identified in (5), specific to Singapore, compute the total number of new cases thereafter. #######
#######	For instance, if the date identified in (5) is Jan-1 2021, the total number of new cases will be the sum of new cases  ##
#######	starting from (inclusive) Jan-1 to the last date in the dataset. 													   ##
################################################################################################################################# 
# new_cases:		new confirmed cases of COVID-19
# Since we want the latest date in the dataset, we only need to set the lower bound of date and not upper bound
# Note: this lower bound is inclusive.
SELECT SUM(new_cases) as total_cases_thereafter
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
#######	For instance, if the date identified in (5) is Jan-1 2021 and the first date recorded          ##
####### (in Singapore) in the dataset is Feb-1 2020, the total number of new cases will be the		   ##
#######	sum of new cases starting from (inclusive) Feb-1 2020 through (inclusive) Dec-31 2020.		   ##
#########################################################################################################
# Since we want the earliest date in the dataset, we only need to set the upper bound of date and not upper bound.
# Note: this upper bound is NOT inclusive.
SELECT SUM(new_cases) AS new_cases_before_date
FROM cases
WHERE location = 'Singapore' 
AND DATE < 
(
	SELECT MIN(date) as date
	FROM vaccinations
	WHERE location = 'Singapore'
	AND daily_vaccinations > 0
);


##################################################################################################
####### 8.	Herd immunity estimation. On a daily basis, specific to Germany, calculate the #######
#######	percentage of new cases (i.e., percentage of new cases = new cases / populations)       ##
#######	and total vaccinations on each available vaccine in relation to its population.         ##
##################################################################################################
# Join our cases and country_vaccinations_by_manufacturer table with the location table on the composite primary key of country & time.
# From here, we calculate the percentage of new cases and vaccinations over total population via the formula below, 
# and group by date and vaccine to show "daily basis" and "each available vaccine" respectively. 
SELECT date, vaccine, new_cases/population * 100 as 'percentage_of_new_cases_(in %)', total_vaccinations/population * 100 as 'percentage_of_total_vaccinations_(in %)'
FROM
cases NATURAL JOIN country_vaccinations_by_manufacturer_sem6_grp2 NATURAL JOIN locations
WHERE location = 'Germany'
GROUP BY date, vaccine;



#######################################################################################################
####### 9.	Vaccination Drivers. Specific to Germany, based on each daily new case, display the #######
####### total vaccinations of each available vaccines after 20 days, 30 days, and 40 days.           ##
#######################################################################################################
SELECT DISTINCT c.date, c.new_cases, c.vaccine,
d20.D20_avail_vaccine AS avail_20_days, 
d30.D30_avail_vaccine AS avail_30_days,
d40.D40_avail_vaccine AS avail_40_days
FROM
( # Create three columns each containing the same data of 1 date (20, 30 and 40 days later respectively)
	SELECT DISTINCT cd.date, cd.new_cases, cm.vaccine, cm.total_vaccinations, 
    date_add(cd.date, interval 20 DAY) AS DAY20, 
    date_add(cd.date, interval 30 DAY) AS DAY30,
    date_add(cd.date, interval 40 DAY) AS DAY40
	FROM cases cd
	JOIN country_vaccinations_by_manufacturer_sem6_grp2 cm on cm.date = cd.date AND cm.location = cd.location
	WHERE cd.location = 'Germany'
) c
# Each of these left joins "duplicates" and "shifts" the vaccinations_by_manufacturer table down.
# We do this three times in total to get the total_vaccinations for 20, 30 and 40 days later respectively.
LEFT JOIN(SELECT date, vaccine, total_vaccinations AS D20_avail_vaccine 
	FROM country_vaccinations_by_manufacturer_sem6_grp2 
	WHERE location = 'Germany') d20 ON d20.date = c.DAY20 AND d20.vaccine = c.vaccine
LEFT JOIN(SELECT date, vaccine, total_vaccinations AS D30_avail_vaccine 
	FROM country_vaccinations_by_manufacturer_sem6_grp2 
	WHERE location = 'Germany') d30 ON d30.date = c.DAY30 AND d30.vaccine = c.vaccine
LEFT JOIN(SELECT date, vaccine, total_vaccinations AS D40_avail_vaccine 
	FROM country_vaccinations_by_manufacturer_sem6_grp2 
	WHERE location = 'Germany') d40 ON d40.date = c.DAY40 AND d40.vaccine = c.vaccine;



##########################################################################################################
####### 10.	Vaccination Effects. Specific to Germany, on a daily basis,	based on the total number  #######
#######	of accumulated vaccinations (sum of total_vaccinations of each vaccine in a day),				##
#######	generate the daily new cases after 21 days, 60 days, and 120 days.								##
##########################################################################################################
# We adopt the same approach as Q9, but implement it using views instead. 
# Views are an easier way to visualise the querying process. # In mySQL's default settings and 
# without an ALGORITHM specified, the MERGE setting is automatically used where the statement 
# retrieves parts of the view definition to replace corresponding parts of the statement in a view resolution.
# This means that no extra space is required to store the view.

# View for sum of total_vaccinations across dates for Germany
CREATE VIEW total AS
	SELECT 
		date , SUM(total_vaccinations) AS total
	FROM country_vaccinations_by_manufacturer_sem6_grp2 cm
	WHERE location = "Germany"
	GROUP BY date
	ORDER BY date;

# Append three columns each containing the same data of 1 date (20, 30 and 40 days later respectively)
CREATE VIEW total_with_lagged_dates AS 
	SELECT *, 
		date_add(total.date, INTERVAL 21 day) AS d21, 
		date_add(total.date, INTERVAL 60 day) AS d60,
		date_add(total.date, INTERVAL 120 day) AS d120
	FROM total;

# Create three different views for new_cases across dates
CREATE VIEW day21_cases AS 
	SELECT date, new_cases AS day21
	FROM cases
	WHERE location = "Germany";

CREATE VIEW day60_cases as 
	SELECT date, new_cases as day60
	FROM cases
	WHERE location = "Germany";

CREATE VIEW day120_cases as 
	SELECT date, new_cases AS day120
	FROM cases
	WHERE location = "Germany";

# Join total_with_lagged_dates with the 3 different views on the lagged dates.
SELECT 
	total_with_lagged_dates.date, total AS sum_of_total_vaccinations, 
	day21 AS daily_new_cases_after_21days, day60 AS daily_new_cases_after_60days, day120 AS daily_new_cases_after_120days
FROM total_with_lagged_dates
LEFT JOIN day21_cases ON total_with_lagged_dates.d21 = day21_cases.date 
LEFT JOIN day60_cases ON total_with_lagged_dates.d60 = day60_cases.date
LEFT JOIN day120_cases ON total_with_lagged_dates.d120 = day120_cases.date;


