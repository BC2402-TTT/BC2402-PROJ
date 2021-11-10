# 0. Verify that each country only has one corresponding multi-valued vaccine entry
SELECT COUNT(DISTINCT vaccines) as numVacs, country FROM country_vaccinations_cleaned
GROUP BY country
ORDER BY numVacs DESC;
# the highest numVacs is 1. Hence, this assumption is verified.

# 1. Determine the maximum number of vaccines a single country has in the vaccines column.
SELECT country, (length(vaccines) - length(REPLACE(vaccines, ';', ''))+1) as maxVaccines FROM country_vaccinations
GROUP BY country
ORDER BY maxVaccines DESC;
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