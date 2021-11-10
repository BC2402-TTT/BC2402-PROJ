use merged_country_vac_manu_covid19data

/* 1.	Display a list of total vaccinations per day in Singapore. */
db.country_vaccinations_cleaned.find(
    {country: "Singapore"},
    {date_cleaned: 1, _id: 0, total_vaccinations_cleaned: 1}
).sort({date_cleaned: 1})


/* 2.	Display the sum of daily vaccinations among ASEAN countries. */
db.country_vaccinations_cleaned.aggregate(
    {$match: {country: {$in: ["Brunei", "Myanmar", "Cambodia", "Indonesia", "Laos", "Malaysia", "Philippines", "Singapore", "Thailand", "Vietnam"]}}},
    {$group: {_id: "$date_cleaned", total_administrated: {$sum: {$round: ["$daily_vaccinations_cleaned", 0]}}}},
    {$sort: {"_id": 1}},
    {$project: {_id: 0, "date": "$_id", "total_administrated": "$total_administrated"}}
)

/* 3.	Identify the maximum daily vaccinations per million of each country. Sort the list based on daily vaccinations per million in a descending order. */
db.country_vaccinations_cleaned.aggregate(
    {$group: {_id: "$country", max_daily_vaccinations_per_million: {$max: "$daily_vaccinations_per_million_cleaned"}}},
    {$sort: {"max_daily_vaccinations_per_million": -1}},
    {$project: {"country": 1, "max_daily_vaccinations_per_million": 1}},
    {$project: {_id: 0, "country": "$_id", "max_daily_vaccinations_per_million": "$max_daily_vaccinations_per_million"}}
)

/* 4.	Which is the most administrated vaccine? Display a list of total administration (i.e., sum of total vaccinations) per vaccine. */
db.country_vac_with_covid19data.aggregate(
    {$match: {vaccinations_by_manufacturer_data: {$exists: true, $ne:[]}}},
    {$unwind: "$vaccinations_by_manufacturer_data"},
    {$group: {_id: "$vaccinations_by_manufacturer_data.vaccine", total_administrated: {$sum: "$vaccinations_by_manufacturer_data.total_vaccinations_cleaned"}}},
    {$sort: {"total_administrated": -1}},
    {$project: {_id: 0,"vaccine": "$_id","total_administrated": "$total_administrated"}}
)

/* 5.	Italy has commenced administrating various vaccines to its populations as a vaccine becomes available. Identify the first dates of each vaccine being administrated, then compute the difference in days between the earliest date and the 4th date. */
db.country_vac_with_covid19data.aggregate(
    {$match: {location: "Italy"}},
    {$match: {vaccinations_by_manufacturer_data: {$exists: true, $ne: []}}},
    {$unwind: "$vaccinations_by_manufacturer_data"},
    {$group: {_id: "$vaccinations_by_manufacturer_data.vaccine", date: {$min: "$date_cleaned"}}},
    {$sort: {"date": 1}},
    {$project: {_id: 0, "vaccine": "$_id", "date": "$date"}}
)

db.country_vac_with_covid19data.aggregate(
    {$match: {location: "Italy"}},
    {$match: {vaccinations_by_manufacturer_data: {$exists: true, $ne: []}}},
    {$unwind: "$vaccinations_by_manufacturer_data"},
    {$group: {_id: "$vaccinations_by_manufacturer_data.vaccine", date: {$min: "$date_cleaned"}}},
    {$group: {_id: null, date: {$addToSet: "$date"}}},
    {$project: {date_diff: {$dateDiff: {startDate: {$min: "$date"}, endDate: {$max: "$date"}, unit: "day"}}}},
    {$project: {_id: 0, "date_diff": "$date_diff"}}
)

/* 6.	What is the country with the most types of administrated vaccine? */
db.country_vac_with_covid19data.aggregate([
    {$group: {_id: {location: "$location", vaccine: "$vaccinations_by_manufacturer_data.vaccine"}}},
    {$project: {_id: 0, location: "$_id.location", all_vaccine:"$_id.vaccine", count: {$size: "$_id.vaccine"}}},
    {$sort: {count: -1}},
    {$limit: 1},
    {$unwind: "$all_vaccine"},
    {$project: {_id: 0,"country": "$location", "vaccine": "$all_vaccine"}}
])

/* 7.   What are the countries that have fully vaccinated more than 60% of its people? For each country, display the vaccines administrated. */
db.country_vaccinations_cleaned.aggregate([
    {$group: {_id: {country: "$country"}, vaccines: {$max: "$vaccines"}, vaccination_percentage: {$max: "$people_fully_vaccinated_per_hundred_cleaned"}}},
    {$match: {"vaccination_percentage": {$gt: 60}}},
    {$project: {_id: 0, "country":"$_id.country", "vaccines": "$vaccines", "vaccination_percentage": "$vaccination_percentage"}},
    {$sort: {vaccination_percentage: -1}}
])

/* 8. Monthly vaccination insight – display the monthly total vaccination amount of each vaccine per month in the United States. */
db.country_vac_with_covid19data.aggregate([
    {$match: {location: "United States"}},
    {$match: {"vaccinations_by_manufacturer_data": {$exists: true, $ne:[]}}},
    {$unwind: "$vaccinations_by_manufacturer_data"},
    {$project: {_id: 0, month: {$month: "$date_cleaned"}, "vaccine": "$vaccinations_by_manufacturer_data.vaccine", "total_vaccinations_cleaned": "$vaccinations_by_manufacturer_data.total_vaccinations_cleaned"}},
    {$group: {_id: {month: "$month", vaccine: "$vaccine"}, monthly_total_vaccination: {$max: "$total_vaccinations_cleaned"}}},
    {$project: {_id: 0,"month": "$_id.month", "vaccine": "$_id.vaccine", "monthly_total_vaccination": "$monthly_total_vaccination"}},
    {$sort: {month: 1}}
])

/* 9. Days to 50 percent. Compute the number of days (i.e., using the first available date on records of a country) that each country takes to go above the 50% threshold of vaccination administration (i.e., total_vaccinations_per_hundred > 50) */
db.country_vaccinations_cleaned.aggregate([
    {$project: {country: 1, date_cleaned: 1, total_vaccinations_per_hundred_cleaned: 1}},
    {$group: {_id: "$country", minDate: {$min: "$date_cleaned"}, date50: {$min: {$cond: [{$gt: ["$total_vaccinations_per_hundred_cleaned", 50]}, "$date_cleaned", null]}}}},
    {$match: {$and: [{date50: {$ne: null}}, {date50: {$exists: true}}]}},
    {$project: {date_diff: {
        $dateDiff: {
            startDate: "$minDate",
            endDate: "$date50",
            unit: "day"
        }
    }}},
    {$project: {_id: 0, "country": "$_id", "days_to_over_50%": "$date_diff"}},
    {$sort: {"country": 1}}
])

/* 10. Compute the global total of vaccinations per vaccine. */
db.country_vac_with_covid19data.aggregate([
    {$match: {"vaccinations_by_manufacturer_data": {$exists: true, $ne: []}}},
    {$unwind: "$vaccinations_by_manufacturer_data"},
    {$group: {_id: {location: "$location", vaccine: "$vaccinations_by_manufacturer_data.vaccine"}, total_vaccination: {$max: "$vaccinations_by_manufacturer_data.total_vaccinations_cleaned"}}},
    {$group: {_id: {vaccine: "$_id.vaccine"}, global_total: {$sum: "$total_vaccination"}}},
    {$project: {_id: 0, vaccine: "$_id.vaccine", global_total: "$global_total"}},
    {$sort: {global_total: -1}}
])

/* 11. What is the total population in Asia? */
db.country_vac_with_covid19data.aggregate([
    {$match: {continent: "Asia"}},
    {$group: {_id: {country: "$location"}, population: {$avg: "$population_cleaned"}}},
    {$group: {_id: null, total_population: {$sum: "$population"}}},
    {$project: {_id: 0, "total_population": "$total_population"}}
])

/* 12. What is the total population among the ten ASEAN countries? */
db.country_vac_with_covid19data.aggregate([
    {$match: {location: {$in: ["Brunei", "Cambodia", "Indonesia", "Laos", "Malaysia", "Myanmar", "Philippines", "Singapore", "Thailand", "Vietnam"]}}},
    {$group: {_id: {location: "$location"}, population: {$max: "$population_cleaned"}}},
    {$group: {_id: null, total_population: {$sum: "$population"}}},
    {$project: {_id: 0, "total_population": "$total_population"}}
])

/* 13. Generate a list of unique data sources (source_name). */
db.country_vaccinations_cleaned.aggregate([
    {$group: {_id:null, unique_data_sources: {$addToSet: "$source_name"}}},
    {$project: {_id: 0, "unique_data_sources": "$unique_data_sources"}}
])

/* 14. Specific to Singapore, display the daily total_vaccinations starting (inclusive) March-1 2021 through (inclusive) May-31 2021. */
db.country_vaccinations_cleaned.aggregate([
    {$match: { $and: [ {country: "Singapore"}, {date_cleaned: {$gte: ISODate("2021-03-01"), $lt: ISODate("2021-04-01")}}]}},
    {$project: {_id:0, date_cleaned: 1, "daily_vaccinations": "$daily_vaccinations"}},
    {$sort: {"date_cleaned": 1}}
])

/* 15. When is the first batch of vaccinations recorded in Singapore? */
db.country_vaccinations_cleaned.aggregate([
    {$match: {$and: [{country: "Singapore"}, {daily_vaccinations_cleaned: {$gt: 0}}]}},
    {$project: {date_cleaned: 1}},
    {$limit: 1},
    {$project: {_id: 0, "first_batch_of_vaccinations":"$date_cleaned"}}
])

/* 16. Based on the date identified in (5), specific to Singapore, compute the total number of new cases thereafter.
For instance, if the date identified in (5) is Jan-1 2021, the total number of new cases will be the sum of new cases starting from (inclusive) Jan-1 to the last date in the dataset. */
db.country_vac_with_covid19data.aggregate([
    {$match: {location: "Singapore"}},
    {$match: {"date_cleaned": {$gte: ISODate("2021-01-12")}}},
    {$group: {_id: null, new_cases_thereafter: {$sum: "$new_cases_cleaned"}}},
    {$project: {_id: 0, "new_cases_thereafter": "$new_cases_thereafter"}}
])

/* 17. Compute the total number of new cases in Singapore before the date identified in (5).
For instance, if the date identified in (5) is Jan-1 2021 and the first date recorded (in Singapore) in the dataset is Feb-1 2020, the total number of new cases will be the sum of new cases starting from (inclusive) Feb-1 2020 through (inclusive) Dec-31 2020. */
db.country_vac_with_covid19data.aggregate([
    {$match: {location: "Singapore"}},
    {$match: {"date_cleaned": {$lt: ISODate("2021-01-12")}}},
    {$group: {_id: null, new_cases_before_date: {$sum: "$new_cases_cleaned"}}},
    {$project: {_id: 0, "new_cases_before_date": "$new_cases_before_date"}}
])

/* 18. Herd immunity estimation. On a daily basis, specific to Germany, calculate the percentage of new cases and total vaccinations on each available vaccine in relation to its population. */
db.country_vac_with_covid19data.aggregate([
    {$match: {location: "Germany"}},
    {$match: {vaccinations_by_manufacturer_data: {$exists: true, $ne: []}}},
    {$unwind: "$vaccinations_by_manufacturer_data"},
    {$project: {date: "$date_cleaned", "percentage_of_new_cases_(in %)": {$multiply: [{$divide: ["$new_cases_cleaned", "$population_cleaned"]}, 100]}, vaccine: "$vaccinations_by_manufacturer_data.vaccine", "percentage_of_total_vaccinations_(in %)": {$multiply: [{$divide: ["$vaccinations_by_manufacturer_data.total_vaccinations_cleaned", "$population_cleaned"]}, 100]}}},
    {$project: {_id: 0, date: 1, "percentage_of_new_cases_(in %)": 1, vaccine: 1, "percentage_of_total_vaccinations_(in %)": 1}},
    {$sort: {date: 1, vaccine: -1}}
])

/* 19. Vaccination Drivers. Specific to Germany, based on each daily new case, display the total vaccinations of each available vaccines after 20 days, 30 days, and 40 days. */
db.country_vac_with_covid19data.aggregate([
    {$match: {location: "Germany"}},
    {$match: {vaccinations_by_manufacturer_data: {$exists: true, $ne: []}}},
    {$lookup: {
        from: "country_vac_with_covid19data",
        let: {date20: {$dateAdd: {startDate: "$date_cleaned", unit: "day", amount: 20}}, location: "$location"},
        pipeline: [{$match: {$expr: {$and: [{$eq: ["$date_cleaned", "$$date20"]}, {$eq: ["$location", "$$location"]}]}}}],
        as: "day_20"
    }},
    {$lookup: {
        from: "country_vac_with_covid19data",
        let: {date30: {$dateAdd: {startDate: "$date_cleaned", unit: "day", amount:30}}, location: "$location"},
        pipeline: [{$match: {$expr: {$and: [{$eq:["$date_cleaned", "$$date30"]}, {$eq:["$location", "$$location"]}]}}}],
        as:"day_30"
    }},
    {$lookup:{
        from: "country_vac_with_covid19data",
        let: {date40: {$dateAdd: {startDate: "$date_cleaned", unit: "day", amount:40}}, location: "$location"},
        pipeline: [{$match: {$expr: {$and: [{$eq:["$date_cleaned", "$$date40"]}, {$eq: ["$location", "$$location"]}]}}}],
        as:"day_40"
    }},
    {$project: {_id: 0, date: 1, new_cases_cleaned: 1, day_20: "$day_20.vaccinations_by_manufacturer_data", day_30: "$day_30.vaccinations_by_manufacturer_data", day_40: "$day_40.vaccinations_by_manufacturer_data"}},
    {$project: {date: 1, new_cases_cleaned: 1, "day_20.vaccine": 1, "day_20.total_vaccinations_cleaned": 1, "day_30.vaccine": 1, "day_30.total_vaccinations_cleaned": 1, "day_40.vaccine": 1, "day_40.total_vaccinations_cleaned": 1}}
])

/* 20. Vaccination Effects. Specific to Germany, on a daily basis, based on the total number of accumulated vaccinations (sum of total_vaccinations of each vaccine in a day), generate the daily new cases after 21 days, 60 days, and 120 days. */
db.country_vac_with_covid19data.aggregate([
    {$match: {location:"Germany"}},
    {$lookup: {
        from:"country_vac_with_covid19data",
        let:{date21: {$dateAdd: {startDate: "$date_cleaned", unit: "day", amount: 21}}, location: "$location"},
        pipeline:[{$match: {$expr: {$and: [{$eq: ["$date_cleaned", "$$date21"]}, {$eq: ["$location", "$$location"]}]}}}],
        as:"day21"}},
    {$lookup: {
        from: "country_vac_with_covid19data",
        let: {date60: {$dateAdd: {startDate: "$date_cleaned", unit: "day", amount: 60}}, location: "$location"},
        pipeline: [{$match: {$expr: {$and: [{$eq: ["$date_cleaned", "$$date60"]}, {$eq: ["$location", "$$location"]}]}}}],
        as: "day60"}},
    {$lookup: {from: "country_vac_with_covid19data", let: {date120: {$dateAdd: {startDate: "$date_cleaned", unit: "day", amount: 120}}, location: "$location"},
        pipeline: [{$match: {$expr: {$and: [{$eq: ["$date_cleaned", "$$date120"]}, {$eq: ["$location", "$$location"]}]}}}],
        as: "day120"}},
    {$match: {vaccinations_by_manufacturer_data: {$exists: true, $ne: []}}},
    {$project: {_id: 0, date: "$date_cleaned", total_vaccinations: {$sum: "$vaccinations_by_manufacturer_data.total_vaccinations_cleaned"}, cases_21: "$day21.new_cases_cleaned", cases_60: "$day60.new_cases_cleaned", cases_120: "$day120.new_cases_cleaned"}}
])
