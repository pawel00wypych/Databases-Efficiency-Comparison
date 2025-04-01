-- Switch to the new user
ALTER SESSION SET CURRENT_SCHEMA = ztbd;


CREATE TABLE google_playstore_ext (
    app_name VARCHAR2(255),
    app_id VARCHAR2(100),
    category VARCHAR2(100),
    rating VARCHAR2(255),
    rating_count VARCHAR2(255),
    installs VARCHAR2(255),
    min_installs VARCHAR2(255),
    max_installs VARCHAR2(255),
    free VARCHAR2(255),
    price VARCHAR2(255),
    currency VARCHAR2(10),
    "size" VARCHAR2(255),
    min_android VARCHAR2(50),
    developer_name VARCHAR2(255),
    developer_website VARCHAR2(255),
    developer_email VARCHAR2(255),
    released VARCHAR2(255),
    last_updated VARCHAR2(255),
    content_rating VARCHAR2(50),
    privacy_policy VARCHAR2(255),
    ad_supported VARCHAR2(255),
    in_app_purchases VARCHAR2(255),
    editor_choice VARCHAR2(255)
)
ORGANIZATION EXTERNAL
(
    TYPE ORACLE_LOADER
    DEFAULT DIRECTORY data_dir
    ACCESS PARAMETERS
    (
        RECORDS DELIMITED BY NEWLINE
        SKIP 1  -- Skip header row
        FIELDS TERMINATED BY ',' OPTIONALLY ENCLOSED BY '"'
        MISSING FIELD VALUES ARE NULL
    )
    LOCATION ('Google-Playstore.csv')
)
REJECT LIMIT UNLIMITED;

