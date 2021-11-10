SET FOREIGN_KEY_CHECKS=0;

ALTER TABLE location
	MODIFY COLUMN location VARCHAR(255),
	ADD CONSTRAINT location_pk PRIMARY KEY (location);
    
ALTER TABLE vaccine
	MODIFY COLUMN vaccine VARCHAR(255),
	ADD CONSTRAINT vaccine_pk PRIMARY KEY (vaccine);


ALTER TABLE cases
	MODIFY COLUMN location VARCHAR(255),
	ADD CONSTRAINT cases_pk PRIMARY KEY (location, date),
    ADD CONSTRAINT cases_fk FOREIGN KEY(location) REFERENCES location(location) ON DELETE RESTRICT ON UPDATE CASCADE;

ALTER TABLE deaths
	MODIFY COLUMN location VARCHAR(255),
	ADD CONSTRAINT deaths_pk PRIMARY KEY (location, date),
    ADD CONSTRAINT deaths_fk FOREIGN KEY(location) REFERENCES location(location) ON DELETE RESTRICT ON UPDATE CASCADE;

ALTER TABLE hospitals
	MODIFY COLUMN location VARCHAR(255),
	ADD CONSTRAINT hospitals_pk PRIMARY KEY (location, date),
    ADD CONSTRAINT hospitals_fk FOREIGN KEY(location) REFERENCES location(location) ON DELETE RESTRICT ON UPDATE CASCADE;

ALTER TABLE iso_code
	MODIFY COLUMN location VARCHAR(255),
	ADD CONSTRAINT iso_code_pk PRIMARY KEY (location),
    ADD CONSTRAINT iso_code_fk FOREIGN KEY(location) REFERENCES location(location) ON DELETE RESTRICT ON UPDATE CASCADE;

ALTER TABLE stringency
	MODIFY COLUMN location VARCHAR(255),
	ADD CONSTRAINT stringency_pk PRIMARY KEY (location, date),
    ADD CONSTRAINT stringency_fk FOREIGN KEY(location) REFERENCES location(location) ON DELETE RESTRICT ON UPDATE CASCADE;

ALTER TABLE tests
	MODIFY COLUMN location VARCHAR(255),
	ADD CONSTRAINT tests_pk PRIMARY KEY (location, date),
    ADD CONSTRAINT tests_fk FOREIGN KEY(location) REFERENCES location(location) ON DELETE RESTRICT ON UPDATE CASCADE;

ALTER TABLE vaccinations
	MODIFY COLUMN location VARCHAR(255),
	ADD CONSTRAINT vaccinations_pk PRIMARY KEY (location, date),
    ADD CONSTRAINT vaccinations_fk FOREIGN KEY(location) REFERENCES location(location) ON DELETE RESTRICT ON UPDATE CASCADE;
    

ALTER TABLE locations_vaccines
	MODIFY COLUMN location VARCHAR(255),
    MODIFY COLUMN vaccine VARCHAR(255),
	ADD CONSTRAINT locations_vaccines_pk PRIMARY KEY (location, vaccine),
    ADD CONSTRAINT locations_vaccines_fk1 FOREIGN KEY(location) REFERENCES location(location) ON DELETE RESTRICT ON UPDATE CASCADE,
    ADD CONSTRAINT locations_vaccines_fk2 FOREIGN KEY(vaccine) REFERENCES vaccine(vaccine) ON DELETE RESTRICT ON UPDATE CASCADE;


ALTER TABLE country_vaccinations_by_manufacturer_cleaned
	MODIFY COLUMN location VARCHAR(255),
    MODIFY COLUMN vaccine VARCHAR(255),
	ADD CONSTRAINT country_vaccinations_by_manufacturer_cleaned_pk PRIMARY KEY (location, date, vaccine),
    ADD CONSTRAINT country_vaccinations_by_manufacturer_fk1 FOREIGN KEY(location) REFERENCES location(location) ON DELETE RESTRICT ON UPDATE CASCADE,
    ADD CONSTRAINT country_vaccinations_by_manufacturer_fk2 FOREIGN KEY(vaccine) REFERENCES vaccine(vaccine) ON DELETE RESTRICT ON UPDATE CASCADE;

SET FOREIGN_KEY_CHECKS=1;
