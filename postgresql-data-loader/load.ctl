COPY staging_table(
    app_name,
    app_address,
    category_name,
    rating_value,
    rating_count,
    installs,
    minimum_installs,
    maximum_installs,
    free,
    price,
    currency_name,
    app_size,
    version,
    developer_name,
    developer_website,
    developer_email,
    released,
    last_updated,
    rating_name,
    privacy_policy,
    ad_supported,
    in_app_purchases
)
FROM '/shared-data/Google-Playstore_cleaned_10000_rows.csv' 
DELIMITER ',' 
CSV HEADER;