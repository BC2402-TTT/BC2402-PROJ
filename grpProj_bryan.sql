##########################################################################################################################################################################################
####### 9.	Vaccination Drivers. 
# Specific to Germany, based on each daily new case, 
# display the total vaccinations of each available vaccines after 20 days, 30 days, and 40 days. #######
##########################################################################################################################################################################################

SELECT * FROM country_vaccinations_by_manufacturer;

SELECT vaccine, MIN((STR_TO_DATE(date, '%Y-%m-%d'))) as minDate FROM country_vaccinations_by_manufacturer
WHERE location = "Germany"
GROUP BY vaccine;
