use country_vaccinations


//cleaning the country_vaccinations dataset, convert from string to double or string to date when necessary

//convert date from string to Date datatype
db.country_vaccinations.find({date: {$exists: true}}).forEach(function(obj) {
    var fields = obj.date.split("/");
    obj.date_cleaned = new Date(fields[2] + "-" + ("0" + fields[0]).slice (-2) + "-" + ("0" + fields[1]).slice (-2));
    db.country_vaccinations.save(obj);
});

//convert total_vaccinations from string to Double data type
db.country_vaccinations.find({total_vaccinations: {$exists: true}}).forEach(function(obj) { 
    obj.total_vaccinations_cleaned = new Double(obj.total_vaccinations);
    db.country_vaccinations.save(obj);
});

//convert people_vaccinated from string to Double data type
db.country_vaccinations.find({people_vaccinated: {$exists: true}}).forEach(function(obj) { 
    obj.people_vaccinated_cleaned = new Double(obj.people_vaccinated);
    db.country_vaccinations.save(obj);
});

//convert people_fully_vaccinated from string to Double data type
db.country_vaccinations.find({people_fully_vaccinated: {$exists: true}}).forEach(function(obj) { 
    obj.people_fully_vaccinated_cleaned = new Double(obj.people_fully_vaccinated);
    db.country_vaccinations.save(obj);
});

//convert daily_vaccinations_raw from string to Double data type
db.country_vaccinations.find({daily_vaccinations_raw: {$exists: true}}).forEach(function(obj) { 
    obj.daily_vaccinations_raw_cleaned = new Double(obj.daily_vaccinations_raw);
    db.country_vaccinations.save(obj);
});

//convert daily_vaccinations from string to Double data type
db.country_vaccinations.find({daily_vaccinations: {$exists: true}}).forEach(function(obj) { 
    obj.daily_vaccinations_cleaned = new Double(obj.daily_vaccinations);
    db.country_vaccinations.save(obj);
});

//convert total_vaccinations_per_hundred from string to Double data type
db.country_vaccinations.find({total_vaccinations_per_hundred: {$exists: true}}).forEach(function(obj) { 
    obj.total_vaccinations_per_hundred_cleaned = new Double(obj.total_vaccinations_per_hundred);
    db.country_vaccinations.save(obj);
});

//convert people_vaccinated_per_hundred from string to Double data type
db.country_vaccinations.find({people_vaccinated_per_hundred: {$exists: true}}).forEach(function(obj) { 
    obj.people_vaccinated_per_hundred_cleaned = new Double(obj.people_vaccinated_per_hundred);
    db.country_vaccinations.save(obj);
});

//convert people_fully_vaccinated_per_hundred from string to Double data type
db.country_vaccinations.find({people_fully_vaccinated_per_hundred: {$exists: true}}).forEach(function(obj) { 
    obj.people_fully_vaccinated_per_hundred_cleaned = new Double(obj.people_fully_vaccinated_per_hundred);
    db.country_vaccinations.save(obj);
});

//convert daily_vaccinations_per_million from string to Double data type
db.country_vaccinations.find({daily_vaccinations_per_million: {$exists: true}}).forEach(function(obj) { 
    obj.daily_vaccinations_per_million_cleaned = new Double(obj.daily_vaccinations_per_million);
    db.country_vaccinations.save(obj);
});

//verify that cleaning has been done for country_vaccinations, new columns of the appropriate datatype are created
db.country_vaccinations.find() //columns that are cleaned are ended with _cleaned for consistency


//cleaning the country_vaccinations_by_manufacturer dataset, convert from string to int or string to date when necessary

//convert date from string to Date data type
db.country_vaccinations_by_manufacturer.find({date: {$exists: true}}).forEach(function(obj) { 
    obj.date_cleaned = new Date(obj.date);
    db.country_vaccinations_by_manufacturer.save(obj);
});

// convert total_vaccinations from string to integer data type
db.country_vaccinations_by_manufacturer.find({total_vaccinations: {$exists: true}}).forEach(function(obj) { 
    obj.total_vaccinations_cleaned = new Double(obj.total_vaccinations);
    db.country_vaccinations_by_manufacturer.save(obj);
});

//verify that cleaning has been done for country_vaccinations_by_manufacturers, new columns of the appropriate datatype are created
db.country_vaccinations_by_manufacturer.find() //columns that are cleaned are ended with _cleaned for consistency

//cleaning covid19_2 dataset

//convert date from string to Date data type
db.covid19data_2.find({date: {$exists: true}}).forEach(function(obj) { 
    obj.date_cleaned = new Date(obj.date);
    db.covid19data_2.save(obj);
});


//convert daily_vaccinations_per_million from string to Double data type
db.covid19data_2.find({total_cases: {$exists: true}}).forEach(function(obj) { 
    obj.total_cases_cleaned = new Double(obj.total_cases);
    db.covid19data_2.save(obj);
});

//convert new_cases from string to Double data type
db.covid19data_2.find({new_cases: {$exists: true}}).forEach(function(obj) { 
    obj.new_cases_cleaned = new Double(obj.new_cases);
    db.covid19data_2.save(obj);
});

//convert new_cases_smoothed from string to Double data type
db.covid19data_2.find({new_cases_smoothed: {$exists: true}}).forEach(function(obj) { 
    obj.new_cases_smoothed_cleaned = new Double(obj.new_cases_smoothed);
    db.covid19data_2.save(obj);
});

//convert total_deaths from string to Double data type
db.covid19data_2.find({total_deaths: {$exists: true}}).forEach(function(obj) { 
    obj.total_deaths_cleaned = new Double(obj.total_deaths);
    db.covid19data_2.save(obj);
});

//convert new_deaths from string to Double data type
db.covid19data_2.find({new_deaths: {$exists: true}}).forEach(function(obj) { 
    obj.new_deaths_cleaned = new Double(obj.new_deaths);
    db.covid19data_2.save(obj);
});

//convert new_deaths_smoothed from string to Double data type
db.covid19data_2.find({new_deaths_smoothed: {$exists: true}}).forEach(function(obj) { 
    obj.new_deaths_smoothed = new Double(obj.new_deaths_smoothed);
    db.covid19data_2.save(obj);
});

//convert total_cases_per_million from string to Double data type
db.covid19data_2.find({total_cases_per_million: {$exists: true}}).forEach(function(obj) { 
    obj.total_cases_per_million = new Double(obj.total_cases_per_million);
    db.covid19data_2.save(obj);
});

//convert new_cases_per_million from string to Double data type
db.covid19data_2.find({new_cases_per_million: {$exists: true}}).forEach(function(obj) { 
    obj.new_cases_per_million_cleaned = new Double(obj.new_cases_per_million);
    db.covid19data_2.save(obj);
});

//convert new_cases_smoothed_per_million from string to Double data type
db.covid19data_2.find({new_cases_smoothed_per_million: {$exists: true}}).forEach(function(obj) { 
    obj.new_cases_smoothed_per_million_cleaned = new Double(obj.new_cases_smoothed_per_million);
    db.covid19data_2.save(obj);
});

//convert total_deaths_per_million from string to Double data type
db.covid19data_2.find({total_deaths_per_million: {$exists: true}}).forEach(function(obj) { 
    obj.total_deaths_per_million_cleaned = new Double(obj.total_deaths_per_million);
    db.covid19data_2.save(obj);
});
 
//convert new_deaths_per_million from string to double data type
db.covid19data_2.find({new_deaths_per_million: {$exists: true}}).forEach(function(obj) { 
    obj.new_deaths_per_million_cleaned = new Double(obj.new_deaths_per_million);
    db.covid19data_2.save(obj);
});

//convert new_deaths_smoothed_per_million from string to Double data type
db.covid19data_2.find({new_deaths_smoothed_per_million: {$exists: true}}).forEach(function(obj) { 
    obj.new_deaths_smoothed_per_million_cleaned = new Double(obj.new_deaths_smoothed_per_million);
    db.covid19data_2.save(obj);
});

//convert population from string to Double data type
db.covid19data_2.find({population: {$exists: true}}).forEach(function(obj) { 
    obj.population_cleaned = new Double(obj.population);
    db.covid19data_2.save(obj);
});

//convert population_density from string to double data type
db.covid19data_2.find({population_density: {$exists: true}}).forEach(function(obj) { 
    obj.population_density_cleaned = new Double(obj.population_density);
    db.covid19data_2.save(obj);
});

//convert median_age from string to Double data type
db.covid19data_2.find({median_age: {$exists: true}}).forEach(function(obj) { 
    obj.median_age_cleaned = new Double(obj.median_age);
    db.covid19data_2.save(obj);
});

//convert aged_65_older from string to Double data type
db.covid19data_2.find({aged_65_older: {$exists: true}}).forEach(function(obj) { 
    obj.aged_65_older_cleaned = new Double(obj.aged_65_older);
    db.covid19data_2.save(obj);
});


//convert aged_70_older from string to double data type
db.covid19data_2.find({aged_70_older: {$exists: true}}).forEach(function(obj) { 
    obj.aged_70_older_cleaned = new Double(obj.aged_70_older);
    db.covid19data_2.save(obj);
});

//convert gdp_per_capita from string to Double data type
db.covid19data_2.find({gdp_per_capita: {$exists: true}}).forEach(function(obj) { 
    obj.gdp_per_capita_cleaned = new Double(obj.gdp_per_capita);
    db.covid19data_2.save(obj);
});

//convert cardiovasc_death_rate from string to Double data type
db.covid19data_2.find({cardiovasc_death_rate: {$exists: true}}).forEach(function(obj) { 
    obj.cardiovasc_death_rate_cleaned = new Double(obj.cardiovasc_death_rate);
    db.covid19data_2.save(obj);
});

//convert diabetes_prevalence from string to double data type
db.covid19data_2.find({diabetes_prevalence: {$exists: true}}).forEach(function(obj) { 
    obj.diabetes_prevalence_cleaned = new Double(obj.diabetes_prevalence);
    db.covid19data_2.save(obj);
});

//convert handwashing_facilities from string to Double data type
db.covid19data_2.find({handwashing_facilities: {$exists: true}}).forEach(function(obj) { 
    obj.handwashing_facilities_cleaned = new Double(obj.handwashing_facilities);
    db.covid19data_2.save(obj);
});

//convert hospital_beds_per_thousand from string to Double data type
db.covid19data_2.find({hospital_beds_per_thousand: {$exists: true}}).forEach(function(obj) { 
    obj.hospital_beds_per_thousand_cleaned = new Double(obj.hospital_beds_per_thousand);
    db.covid19data_2.save(obj);
});

//convert life_expectancy from string to Double data type
db.covid19data_2.find({life_expectancy: {$exists: true}}).forEach(function(obj) { 
    obj.life_expectancy_cleaned = new Double(obj.life_expectancy);
    db.covid19data_2.save(obj);
});

//convert human_development_index from string to Double data type
db.covid19data_2.find({human_development_index: {$exists: true}}).forEach(function(obj) { 
    obj.human_development_index_cleaned = new Double(obj.human_development_index);
    db.covid19data_2.save(obj);
});

//verify that cleaning has been done, new columns of the appropriate datatype are created for covid19data_2
db.covid19data_2.find() //columns that are cleaned are ended with _cleaned for consistency