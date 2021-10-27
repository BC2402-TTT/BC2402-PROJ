SELECT COLUMN_NAME, DATA_TYPE from INFORMATION_SCHEMA.COLUMNS
WHERE table_name = "country_vaccinations_by_manufacturer";

# 1. Create a new table called "country_vaccinations_sem6_grp2"
CREATE TABLE country_vaccinations_by_manufacturer_sem6_grp2 AS SELECT * FROM country_vaccinations_by_manufacturer;

# 2. The formatting of date here is correct (unlike country_vaccinations)
# Hence, we don't need to transform anything. very good

# 3. Change the data types
ALTER TABLE country_vaccinations_by_manufacturer_sem6_grp2
	MODIFY COLUMN location								TEXT,
    MODIFY COLUMN date									DATE,
	MODIFY COLUMN vaccine								TEXT,
    MODIFY COLUMN total_vaccinations					BIGINT;
    
# 4. Verify that the datatypes have been changed
SELECT COLUMN_NAME, DATA_TYPE from INFORMATION_SCHEMA.COLUMNS
WHERE table_name = "country_vaccinations_by_manufacturer_sem6_grp2";

# 5. Verify that the data values remain unchanged
SELECT * FROM country_vaccinations_by_manufacturer_sem6_grp2;