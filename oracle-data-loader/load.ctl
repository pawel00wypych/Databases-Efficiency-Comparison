LOAD DATA
INFILE '/shared-data/Google-Playstore_cleaned.csv'
TRUNCATE
INTO TABLE developer
FIELDS TERMINATED BY ',' OPTIONALLY ENCLOSED BY '"'
TRAILING NULLCOLS
(
    filler_field1 FILLER,   -- 1st Column: app_name
    filler_field2 FILLER,   -- 2nd Column: app_id
    filler_field3 FILLER,   -- 3rd Column: category
    filler_field4 FILLER,   -- 4th Column: rating
    filler_field5 FILLER,   -- 5th Column: rating count
    filler_field6 FILLER,   -- 6th Column: installs
    filler_field7 FILLER,   -- 7th Column: minimum installs
    filler_field8 FILLER,   -- 8th Column: maximum installs
    filler_field9 FILLER,   -- 9th Column: free
    filler_field10 FILLER,   -- 10th Column: price
    filler_field11 FILLER,   -- 11th Column: currency
    filler_field12 FILLER,   -- 12th Column: size
    filler_field13 FILLER,   -- 13th Column: minimum android
    developer_name,   -- 14th Column
    developer_website, -- 15th Column
    developer_email
)
INTO TABLE currency
FIELDS TERMINATED BY ',' OPTIONALLY ENCLOSED BY '"'
TRAILING NULLCOLS
(
    filler_field1 FILLER POSITION(1),   -- 1st Column: app_name
    filler_field2 FILLER,   -- 2nd Column: app_id
    filler_field3 FILLER,   -- 3rd Column: category
    filler_field4 FILLER,   -- 4th Column: rating
    filler_field5 FILLER,   -- 5th Column: rating count
    filler_field6 FILLER,   -- 6th Column: installs
    filler_field7 FILLER,   -- 7th Column: minimum installs
    filler_field8 FILLER,   -- 8th Column: maximum installs
    filler_field9 FILLER,   -- 9th Column: free
    filler_field10 FILLER,   -- 10th Column: price
    currency_name
)
INTO TABLE content_rating
FIELDS TERMINATED BY ',' OPTIONALLY ENCLOSED BY '"'
TRAILING NULLCOLS
(
    filler_field1 FILLER POSITION(1),   -- 1st Column: app_name
    filler_field2 FILLER,   -- 2nd Column: app_id
    filler_field3 FILLER,   -- 3rd Column: category
    filler_field4 FILLER,   -- 4th Column: rating
    filler_field5 FILLER,   -- 5th Column: rating count
    filler_field6 FILLER,   -- 6th Column: installs
    filler_field7 FILLER,   -- 7th Column: minimum installs
    filler_field8 FILLER,   -- 8th Column: maximum installs
    filler_field9 FILLER,   -- 9th Column: free
    filler_field10 FILLER,   -- 10th Column: price
    filler_field11 FILLER,   -- 11th Column: currency
    filler_field12 FILLER,   -- 12th Column: size
    filler_field13 FILLER,   -- 13th Column: minimum android
    filler_field14 FILLER, -- 14th Column: developer_name
    filler_field15 FILLER, -- 15th Column: developer_website
    filler_field16 FILLER, -- 16th Column: developer_email
    filler_field17 FILLER, -- 17th Column: released
    filler_field18 FILLER, -- 18th Column: last updated
    rating_name
)
INTO TABLE category
FIELDS TERMINATED BY ',' OPTIONALLY ENCLOSED BY '"'
TRAILING NULLCOLS
(
    filler_field1 FILLER POSITION(1),   -- 1st Column: app_name
    filler_field2 FILLER,   -- 2nd Column: app_id
    category_name
)
INTO TABLE minimum_android
FIELDS TERMINATED BY ',' OPTIONALLY ENCLOSED BY '"'
TRAILING NULLCOLS
(
    filler_field1 FILLER POSITION(1),   -- 1st Column: app_name
    filler_field2 FILLER,   -- 2nd Column: app_id
    filler_field3 FILLER,   -- 3rd Column: category
    filler_field4 FILLER,   -- 4th Column: rating
    filler_field5 FILLER,   -- 5th Column: rating count
    filler_field6 FILLER,   -- 6th Column: installs
    filler_field7 FILLER ,   -- 7th Column: minimum installs
    filler_field8 FILLER,   -- 8th Column: maximum installs
    filler_field9 FILLER,   -- 9th Column: free
    filler_field10 FILLER,   -- 10th Column: price
    filler_field11 FILLER,   -- 11th Column: currency
    filler_field12 FILLER,   -- 12th Column: size
    version
)