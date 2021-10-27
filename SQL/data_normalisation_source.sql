CREATE TABLE source_sem6_grp2 AS
SELECT location, source_name, source_website
FROM
country_vaccinations_sem6_grp2;

ALTER TABLE country_vaccinations_sem6_grp2
	DROP source_name,
    DROP source_website;
SELECT * FROM country_vaccinations_sem6_grp2;

SELECT * FROM source_sem6_grp2;