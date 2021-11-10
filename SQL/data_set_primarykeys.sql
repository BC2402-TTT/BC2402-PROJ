ALTER TABLE cases
	MODIFY COLUMN location VARCHAR(255),
	ADD CONSTRAINT cases_pk PRIMARY KEY (location, date);

ALTER TABLE country_vaccinations_by_manufacturer_cleaned
	MODIFY COLUMN location VARCHAR(255),
    MODIFY COLUMN vaccine VARCHAR(255),
	ADD CONSTRAINT country_vaccinations_by_manufacturer_cleaned_pk PRIMARY KEY (location, date, vaccine);

ALTER TABLE deaths
	MODIFY COLUMN location VARCHAR(255),
	ADD CONSTRAINT deaths_pk PRIMARY KEY (location, date);

ALTER TABLE hospitals
	MODIFY COLUMN location VARCHAR(255),
	ADD CONSTRAINT hospitals_pk PRIMARY KEY (location, date);

ALTER TABLE iso_code
	MODIFY COLUMN location VARCHAR(255),
	ADD CONSTRAINT iso_code_pk PRIMARY KEY (location);

ALTER TABLE location
	MODIFY COLUMN location VARCHAR(255),
	ADD CONSTRAINT location_pk PRIMARY KEY (location);

ALTER TABLE locations_vaccines
	MODIFY COLUMN location VARCHAR(255),
    MODIFY COLUMN vaccine VARCHAR(255),
	ADD CONSTRAINT locations_vaccines_pk PRIMARY KEY (location, vaccine);

ALTER TABLE stringency
	MODIFY COLUMN location VARCHAR(255),
	ADD CONSTRAINT stringency_pk PRIMARY KEY (location, date);

ALTER TABLE tests
	MODIFY COLUMN location VARCHAR(255),
	ADD CONSTRAINT tests_pk PRIMARY KEY (location, date);

ALTER TABLE vaccinations
	MODIFY COLUMN location VARCHAR(255),
	ADD CONSTRAINT vaccinations_pk PRIMARY KEY (location, date);

ALTER TABLE vaccine
	MODIFY COLUMN vaccine VARCHAR(255),
	ADD CONSTRAINT vaccine_pk PRIMARY KEY (vaccine);
            
