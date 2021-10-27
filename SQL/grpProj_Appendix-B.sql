#########################################################
####### 1.	What is the total population in Asia? #######
#########################################################
SELECT SUM(population) AS total_population_in_asia 
FROM (SELECT MAX(CAST(IFNULL(NULLIF(population, ''), 0.0) AS DECIMAL(11,1))) AS population 
      FROM covid19data 
      WHERE continent = 'Asia' 
      GROUP BY location) AS subquery;

SELECT SUM(population) AS total_population_in_asia 
FROM (SELECT population 
      FROM covid19data 
      WHERE continent = 'Asia' 
      GROUP BY location) AS subquery;
###############################################################################
####### 2.	What is the total population among the ten ASEAN countries? #######
###############################################################################
SELECT SUM(population) AS total_asean_population_top_ten 
FROM (SELECT MAX(CAST(IFNULL(NULLIF(population, ''), 0.0) AS DECIMAL(11,1))) AS population 
      FROM covid19data 
      WHERE location IN ('Brunei', 'Cambodia', 'Indonesia', 'Laos', 'Malaysia', 'Myanmar', 'Philippines', 'Singapore', 'Thailand', 'Vietnam') 
      GROUP BY location 
      ORDER BY MAX(CAST(IFNULL(NULLIF(population, ''), 0.0) AS DECIMAL(11,1))) DESC LIMIT 10) AS subquery;

SELECT SUM(population) AS total_asean_population_top_ten 
FROM (SELECT population 
      FROM covid19data 
      WHERE location IN ('Brunei', 'Cambodia', 'Indonesia', 'Laos', 'Malaysia', 'Myanmar', 'Philippines', 'Singapore', 'Thailand', 'Vietnam') 
      GROUP BY location 
      ORDER BY population) AS subquery;
#########################################################################
####### 3.	Generate a list of unique data sources (source_name). #######
#########################################################################
SELECT DISTINCT source_name 
FROM country_vaccinations 
ORDER BY source_name;

##################################################################################################################################################
####### 4.	Specific to Singapore, display the daily total_vaccinations starting (inclusive) March-1 2021 through (inclusive) May-31 2021. #######
##################################################################################################################################################
SELECT STR_TO_DATE(date, '%c/%e/%Y') AS date, GREATEST(daily_vaccinations, daily_vaccinations_raw) AS daily_total_vaccinations 
FROM country_vaccinations 
WHERE country = 'Singapore' AND STR_TO_DATE(date, '%c/%e/%Y') BETWEEN '2021-03-01' AND '2021-05-31';

##################################################################################
####### 5.	When is the first batch of vaccinations recorded in Singapore? #######
##################################################################################
SELECT MIN(STR_TO_DATE(date, '%c/%e/%Y')) AS date 
FROM country_vaccinations 
WHERE country = 'Singapore' 
AND GREATEST(daily_vaccinations, daily_vaccinations_raw) > 0;

#################################################################################################################################
####### 6.	Based on the date identified in (5), specific to Singapore, compute the total number of new cases thereafter. #######
# For instance, if the date identified in (5) is Jan-1 2021, the total number of new cases will be the sum of new cases 
# starting from (inclusive) Jan-1 to the last date in the dataset.
################################################################################################################################# 
SELECT SUM(CAST(IFNULL(NULLIF(new_cases, ''), 0.0) AS DECIMAL(11,1))) AS new_cases 
FROM covid19data 
WHERE location = 'Singapore' 
AND STR_TO_DATE(date, '%Y-%c-%d') >= (SELECT MIN(STR_TO_DATE(date, '%c/%e/%Y')) 
                                      FROM country_vaccinations 
                                      WHERE country = 'Singapore' 
                                      AND GREATEST(daily_vaccinations, daily_vaccinations_raw) > 0);

#########################################################################################################
####### 7.	Compute the total number of new cases in Singapore before the date identified in (5). #######
# For instance, if the date identified in (5) is Jan-1 2021 and the first date recorded (in Singapore) 
# in the dataset is Feb-1 2020, the total number of new cases will be the sum of new cases starting 
# from (inclusive) Feb-1 2020 through (inclusive) Dec-31 2020.
#########################################################################################################
SELECT SUM(CAST(IFNULL(NULLIF(new_cases, ''), 0.0) AS DECIMAL(11,1))) AS new_cases 
FROM covid19data 
WHERE location = 'Singapore' AND STR_TO_DATE(date, '%Y-%c-%d') <= (SELECT MIN(STR_TO_DATE(date, '%c/%e/%Y')) 
                                                                   FROM country_vaccinations 
                                                                   WHERE country = 'Singapore' 
                                                                   AND GREATEST(daily_vaccinations, daily_vaccinations_raw) > 0);

####################################################################################################################################################################################################################################################################
####### 8.	Herd immunity estimation. On a daily basis, specific to Germany, calculate the percentage of new cases (i.e., percentage of new cases = new cases / populations) and total vaccinations on each available vaccine in relation to its population. #######
####################################################################################################################################################################################################################################################################
SELECT STR_TO_DATE(covid19data.date, '%Y-%c-%d') AS date, CAST(IFNULL(NULLIF(new_cases, ''), 0.0) AS DECIMAL(11,1)) / CAST(IFNULL(NULLIF(population, ''), 0.0) AS DECIMAL(11,1)) AS percentage_of_new_cases, vaccine, GREATEST(daily_vaccinations_raw, daily_vaccinations) / CAST(IFNULL(NULLIF(population, ''), 0.0) AS DECIMAL(11,1)) AS vaccinations_against_population 
FROM covid19data 
INNER JOIN country_vaccinations_by_manufacturer ON covid19data.location = country_vaccinations_by_manufacturer.location AND covid19data.date = country_vaccinations_by_manufacturer.date 
INNER JOIN country_vaccinations ON country_vaccinations_by_manufacturer.location = country AND STR_TO_DATE(country_vaccinations_by_manufacturer.date, '%Y-%c-%d') = STR_TO_DATE(country_vaccinations.date, '%c/%e/%Y') 
WHERE covid19data.location = 'Germany' 
ORDER BY STR_TO_DATE(covid19data.date, '%Y-%c-%d');

##########################################################################################################################################################################################
####### 9.	Vaccination Drivers. Specific to Germany, based on each daily new case, display the total vaccinations of each available vaccines after 20 days, 30 days, and 40 days. #######
##########################################################################################################################################################################################
select distinct c.date, c.new_cases, c.vaccine,
d20.D20_avail_vaccine-c.total_vaccinations as D20_vaccine, 
d30.D30_avail_vaccine-c.total_vaccinations as D30_vaccine
, d40.D40_avail_vaccine-c.total_vaccinations as D40_vaccine
from 
(select distinct str_to_date(cd.date,'%Y-%m-%d') as date, cd.new_cases, cm.vaccine, cm.total_vaccinations, date_add(str_to_date(cd.date,'%Y-%m-%d'), interval 20 DAY) AS DAY20, date_add(str_to_date(cd.date,'%Y-%m-%d'), interval 30 DAY) AS DAY30, date_add(str_to_date(cd.date,'%Y-%m-%d'), interval 40 DAY) AS DAY40
FROM covid19data cd
join country_vaccinations_by_manufacturer cm on cm.date = cd.date
where cd.location = 'Germany'
) c
left join(select str_to_date(date,'%Y-%m-%d') as date, vaccine, total_vaccinations as D20_avail_vaccine from country_vaccinations_by_manufacturer where location = 'Germany') d20 on d20.date = c.DAY20 and d20.vaccine = c.vaccine
left join(select str_to_date(date,'%Y-%m-%d') as date, vaccine, total_vaccinations as D30_avail_vaccine from country_vaccinations_by_manufacturer where location = 'Germany') d30 on d30.date = c.DAY30 and d30.vaccine = c.vaccine
left join(select str_to_date(date,'%Y-%m-%d') as date, vaccine, total_vaccinations as D40_avail_vaccine from country_vaccinations_by_manufacturer where location = 'Germany') d40 on d40.date = c.DAY40 and d40.vaccine = c.vaccine
;

##############################################################################################################################################################################################################################################################
####### 10.	Vaccination Effects. Specific to Germany, on a daily basis, based on the total number of accumulated vaccinations (sum of total_vaccinations of each vaccine in a day), generate the daily new cases after 21 days, 60 days, and 120 days. #######
##############################################################################################################################################################################################################################################################
CREATE VIEW ger_vaccinations AS
    SELECT 
        cd.date,
        cd.new_cases,
        cv.total_vaccinations,
        cv.vaccine,
        DATE_ADD(STR_TO_DATE(cd.date, '%Y-%m-%d'),
            INTERVAL 21 DAY) AS d21,
        DATE_ADD(STR_TO_DATE(cd.date, '%Y-%m-%d'),
            INTERVAL 60 DAY) AS d60,
        DATE_ADD(STR_TO_DATE(cd.date, '%Y-%m-%d'),
            INTERVAL 120 DAY) AS d120
    FROM
        covid19data cd,
        country_vaccinations_by_manufacturer cv
    WHERE
        cd.location = cv.location
            AND cv.date = cd.date
            AND cd.location = 'Germany';
            
SELECT 
    gv.date,
    gv.new_cases,
    gv.total_vaccinations,
    gv.vaccine,
    v2.new_cases AS aft21days,
    v3.new_cases AS aft60days,
    v4.new_cases AS aft120days
FROM
    ger_vaccinations gv
        LEFT JOIN
    (SELECT 
        date, new_cases
    FROM
        covid19data
    WHERE
        location = 'Germany') v2 ON gv.d21 = v2.date
        LEFT JOIN
    (SELECT 
        date, new_cases
    FROM
        covid19data
    WHERE
        location = 'Germany') v3 ON gv.d60 = v3.date
        LEFT JOIN
    (SELECT 
        date, new_cases
    FROM
        covid19data
    WHERE
        location = 'Germany') v4 ON gv.d120 = v4.date;
