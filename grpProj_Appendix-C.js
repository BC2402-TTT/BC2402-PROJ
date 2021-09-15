use country_vaccinations

// Q1
db.country_vaccinations.aggregate([{$match: {country: "Singapore"}}, {$project: {_id: 0, date: 1, total_vaccinations: 1}}])

// Q2
db.country_vaccinations.aggregate([{$match: {country: {$in: ["Brunei", "Cambodia", "Indonesia", "Laos", "Malaysia", "Myanmar", "Philippines", "Singapore", "Thailand", "Vietnam"]}}}, {$group: {_id:{fixed_date: {$dateToString: {date: {$dateFromString: {dateString: "$date", format: "%m/%d/%Y"}}, format: "%m/%d/%Y"}}}, vaccinations_total: {$sum: {$toInt: "$daily_vaccinations"}}}}, {$sort: {"_id.fixed_date": 1}}])

// Q3
db.country_vaccinations.aggregate([{$group: {_id:{country: "$country"}, "max(daily_vaccinations_per_million)": {$max: {$toInt: "$daily_vaccinations_per_million"}}}}, {$sort: {"max(daily_vaccinations_per_million)": -1}}])

// Q4
db.country_vaccinations_by_manufacturer.aggregate([{$group: {_id:{vaccine: "$vaccine"}, total_administrated: {$sum: {$toInt: "$total_vaccinations"}}}}, {$sort: {total_administrated: -1}}])

// Q5
db.country_vaccinations_by_manufacturer.aggregate([{$match: {location: "Italy"}}, {$group: {_id:{vaccine: "$vaccine"}, date: {$min: "$date"}}}, {$sort: {date: 1}}])

// Q6
