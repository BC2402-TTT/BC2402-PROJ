use country_vaccinations


//cleaning the country_vaccinations dataset, convert from string to int or string to date when necessary

//convert date from string to Date datatype
db.country_vaccinations.find({date: {$exists: true}}).forEach(function(obj) { 
    obj.date_cleaned = new Date(obj.date);
    db.country_vaccinations.save(obj);
});

//convert total_vaccinations from string to Int data type
db.country_vaccinations.find({total_vaccinations: {$exists: true}}).forEach(function(obj) { 
    obj.total_vaccinations_cleaned = new NumberInt(obj.total_vaccinations);
    db.country_vaccinations.save(obj);
});

//convert people_vaccinated from string to Int data type
db.country_vaccinations.find({people_vaccinated: {$exists: true}}).forEach(function(obj) { 
    obj.people_vaccinated_cleaned = new NumberInt(obj.people_vaccinated);
    db.country_vaccinations.save(obj);
});

//convert people_fully_vaccinated from string to Int data type
db.country_vaccinations.find({people_fully_vaccinated: {$exists: true}}).forEach(function(obj) { 
    obj.people_fully_vaccinated_cleaned = new NumberInt(obj.people_fully_vaccinated);
    db.country_vaccinations.save(obj);
});

//convert daily_vaccinations_raw from string to Int data type
db.country_vaccinations.find({daily_vaccinations_raw: {$exists: true}}).forEach(function(obj) { 
    obj.daily_vaccinations_raw_cleaned = new NumberInt(obj.daily_vaccinations_raw);
    db.country_vaccinations.save(obj);
});

//convert daily_vaccinations from string to Int data type
db.country_vaccinations.find({daily_vaccinations: {$exists: true}}).forEach(function(obj) { 
    obj.daily_vaccinations_cleaned = new NumberInt(obj.daily_vaccinations);
    db.country_vaccinations.save(obj);
});

//convert total_vaccinations_per_hundred from string to Int data type
db.country_vaccinations.find({total_vaccinations_per_hundred: {$exists: true}}).forEach(function(obj) { 
    obj.total_vaccinations_per_hundred_cleaned = new NumberInt(obj.total_vaccinations_per_hundred);
    db.country_vaccinations.save(obj);
});

//convert people_vaccinated_per_hundred from string to Int data type
db.country_vaccinations.find({people_vaccinated_per_hundred: {$exists: true}}).forEach(function(obj) { 
    obj.people_vaccinated_per_hundred_cleaned = new NumberInt(obj.people_vaccinated_per_hundred);
    db.country_vaccinations.save(obj);
});

//convert people_fully_vaccinated_per_hundred from string to Int data type
db.country_vaccinations.find({people_fully_vaccinated_per_hundred: {$exists: true}}).forEach(function(obj) { 
    obj.people_fully_vaccinated_per_hundred_cleaned = new NumberInt(obj.people_fully_vaccinated_per_hundred);
    db.country_vaccinations.save(obj);
});

//convert daily_vaccinations_per_million from string to Int data type
db.country_vaccinations.find({daily_vaccinations_per_million: {$exists: true}}).forEach(function(obj) { 
    obj.daily_vaccinations_per_million_cleaned = new NumberInt(obj.daily_vaccinations_per_million);
    db.country_vaccinations.save(obj);
});

//verify that cleaning has been done, new columns of the appropriate datatype are created
db.country_vaccinations.find() //columns that are cleaned are ended with _cleaned for consistency


//cleaning the country_vaccinations_by_manufacturer dataset, convert from string to int or string to date when necessary

//convert date from string to Date data type
db.country_vaccinations_by_manufacturer.find({date: {$exists: true}}).forEach(function(obj) { 
    obj.date_cleaned = new Date(obj.date);
    db.country_vaccinations_by_manufacturer.save(obj);
});

// convert total_vaccinations from string to integer data type
db.country_vaccinations_by_manufacturer.find({total_vaccinations: {$exists: true}}).forEach(function(obj) { 
    obj.total_vaccinations_cleaned = new NumberInt(obj.total_vaccinations);
    db.country_vaccinations_by_manufacturer.save(obj);
});

//verify that cleaning has been done, new columns of the appropriate datatype are created
db.country_vaccinations_by_manufacturer.find() //columns that are cleaned are ended with _cleaned for consistency



/* 1.	Display a list of total vaccinations per day in Singapore. 
[source table: country_vaccinations] */
db.country_vaccinations.find(
    {country: "Singapore"},
    {date:1, _id:0,total_vaccinations_cleaned:1}
)


/* 2.	Display the sum of daily vaccinations among ASEAN countries.
[source table: country_vaccinations] */
db.country_vaccinations.aggregate(
    {$match:{country: {$in: ["Brunei", "Myanmar" , "Cambodia" , "Indonesia", "Laos", "Malaysia", "Philippines", "Singapore", "Thailand", "Vietnam"]}}},
    {$group: {_id:"$date_cleaned",total_administrated:{$sum: {$round : ["$daily_vaccinations_cleaned",0]} } } },
    {$sort: {"_id":1}},
    {$project: {"total_administrated":1}}
)


/* 3.	Identify the maximum daily vaccinations per million of each country. Sort the list based on daily vaccinations per million in a descending order.
[source table: country_vaccinations] */
db.country_vaccinations.aggregate(
    {$group: {_id:"$country", max_daily_vaccinations_per_million: {$max: "$daily_vaccinations_per_million_cleaned"} } }
    {$sort: {"max_daily_vaccinations_per_million_cleaned":-1}},
    {$project: {"country": 1, "max_daily_vaccinations_per_million":1}}
)

/* 4.	Which is the most administrated vaccine? Display a list of total administration (i.e., sum of total vaccinations) per vaccine.
[source table: country_vaccinations_by_manufacturer] */
db.country_vaccinations_by_manufacturer.aggregate(
    {$group: {_id:"$vaccine", total_administrated: {$sum: "$total_vaccinations_cleaned"} } }
    {$sort: {"total_administrated":-1}},
    {$project: {"vaccine": 1, "total_administrated":1}}
)

/* 5.	Italy has commenced administrating various vaccines to its populations as a vaccine becomes available. Identify the first dates of each vaccine being administrated, then compute the difference in days between the earliest date and the 4th date.
[source table: country_vaccinations_by_manufacturer] */
db.country_vaccinations_by_manufacturer.aggregate(
    {$match:{location: "Italy" } }, 
    {$group:{_id:"$vaccine", date:{$min:"$date_cleaned"} } },
    {$sort: {"date_cleaned" : 1 } }
    {$project: {"vaccine" : 1, "date" : 1} }
)

/* 6.	What is the country with the most types of administrated vaccine?
[source table: country_vaccinations_by_manufacturer] */
