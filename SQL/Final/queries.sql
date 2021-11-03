#########################################################################
####### 3.	Generate a list of unique data sources (source_name). #######
#########################################################################
SELECT DISTINCT source_name 
FROM sources 
ORDER BY source_name;

##################################################################################################################################################
####### 4.	Specific to Singapore, display the daily total_vaccinations starting (inclusive) March-1 2021 through (inclusive) May-31 2021. #######
##################################################################################################################################################
SELECT date, GREATEST(daily_vaccinations, daily_vaccinations_raw) AS daily_total_vaccinations 
FROM vaccinations 
WHERE location = 'Singapore' AND date BETWEEN '2021-03-01' AND '2021-05-31';