SELECT COLUMN_NAME, DATA_TYPE from INFORMATION_SCHEMA.COLUMNS
WHERE table_name = "country_vaccinations";

# 1. Create a new table called "country_vaccinations_cleaned"
CREATE TABLE country_vaccinations_cleaned AS SELECT * FROM country_vaccinations;

# 2. Change the formatting of the DATE column to proper mySQL format. We need to do this, else mySQL cannot modify the column to be DATE datatype in the next step
# Note: need to set SAFE_UPDATES flag to off because we are not specifying a primary key in the WHERE clause -
## we don't need to, because every row has to be updated anyway.
# We set the flag back on afterward
SET SQL_SAFE_UPDATES = 0;
UPDATE country_vaccinations_cleaned SET date = STR_TO_DATE(date, '%c/%e/%Y');
SET SQL_SAFE_UPDATES = 1;

# 3. Change the data types
ALTER TABLE country_vaccinations_cleaned
	#country	-->										TEXT
    #iso_code	--> 									TEXT
	MODIFY COLUMN date									DATE,
    MODIFY COLUMN total_vaccinations					BIGINT,
	MODIFY COLUMN people_vaccinated						BIGINT,
    MODIFY COLUMN people_fully_vaccinated				BIGINT,
    MODIFY COLUMN daily_vaccinations_raw				INT,
    MODIFY COLUMN daily_vaccinations					INT,
    MODIFY COLUMN total_vaccinations_per_hundred		DECIMAL(12,3),
    MODIFY COLUMN people_vaccinated_per_hundred			DECIMAL(12,3),
    MODIFY COLUMN people_fully_vaccinated_per_hundred	DECIMAL(12,3),
    MODIFY COLUMN daily_vaccinations_per_million		INT,
    MODIFY COLUMN vaccines								TEXT,
	MODIFY COLUMN source_name							TEXT,
    MODIFY COLUMN source_website						TEXT;
    
# 4. Verify that the datatypes have been changed
SELECT COLUMN_NAME, DATA_TYPE from INFORMATION_SCHEMA.COLUMNS
WHERE table_name = "country_vaccinations_cleaned";

# 5. Verify that the data values remain unchanged
SELECT * FROM country_vaccinations_cleaned;