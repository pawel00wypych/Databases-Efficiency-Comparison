LOAD DATA
INFILE '/shared-data/Google-Playstore_cleaned.csv'
APPEND INTO TABLE developer
FIELDS TERMINATED BY ',' OPTIONALLY ENCLOSED BY '"'
(
    filler_field1 FILLER CHAR,   -- 1st Column: app_name
    filler_field2 FILLER CHAR,   -- 2nd Column: app_id
    filler_field3 FILLER CHAR,   -- 3rd Column: category
    filler_field4 FILLER CHAR,   -- 4th Column: rating
    filler_field5 FILLER CHAR,   -- 5th Column: rating count
    filler_field6 FILLER CHAR,   -- 6th Column:
    filler_field7 FILLER CHAR,   -- 7th Column:
    filler_field8 FILLER CHAR,   -- 8th Column:
    filler_field9 FILLER CHAR,   -- 9th Column:
    filler_field10 FILLER CHAR,   -- 10th Column:
    filler_field11 FILLER CHAR,   -- 11th Column:
    filler_field12 FILLER CHAR,   -- 12th Column:
    filler_field13 FILLER CHAR,   -- 13th Column:
    developer_name CHAR,   -- 14th Column
    developer_website CHAR, -- 15th Column
    developer_email   CHAR  -- 16th Column
    -- Remaining columns are ignored
)
