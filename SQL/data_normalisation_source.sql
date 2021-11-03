CREATE TABLE sources AS
SELECT location, source_name, source_website
FROM
country_vaccinations_cleaned
GROUP BY source_website;

ALTER TABLE country_vaccinations_cleaned
	DROP source_name,
    DROP source_website;
SELECT * FROM country_vaccinations_cleaned;

SELECT * FROM sources;