LOAD DATA
INFILE '/shared-data/Google-Playstore_cleaned.csv'
INTO TABLE staging_table
FIELDS TERMINATED BY ',' OPTIONALLY ENCLOSED BY '"'
(
    app_name,
    app_address,
    category_name,
    rating_value,
    rating_count,
    installs,
    minimum_installs,
    maximum_installs,
    free CHAR(1) "CASE WHEN LENGTH(:free) = 1 THEN :free ELSE '0' END",
    price,
    currency_name,
    app_size,
    version,
    developer_name,
    developer_website,
    developer_email,
    released DATE "DD-MM-YYYY",
    last_updated DATE "DD-MM-YYYY",
    rating_name,
    privacy_policy CHAR(1000) "SUBSTR(:privacy_policy, 1, 1000)",
    ad_supported  CHAR(1) "CASE WHEN LENGTH(:ad_supported) = 1 THEN :ad_supported ELSE '0' END",
    in_app_purchases  CHAR(1) "CASE WHEN LENGTH(:in_app_purchases) = 1 THEN :in_app_purchases ELSE '0' END"
)