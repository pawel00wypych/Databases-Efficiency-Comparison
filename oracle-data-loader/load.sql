-- Switch to the ztbd user
ALTER SESSION SET CURRENT_SCHEMA = ztbd;

BEGIN
EXECUTE IMMEDIATE 'DROP TABLE google_playstore_ext';
EXCEPTION
    WHEN OTHERS THEN
        NULL;  -- Ignore if table doesn't exist
END;
/

CREATE OR REPLACE DIRECTORY
    ext_data_dir AS '/opt/oracle/shared-data';
GRANT READ, WRITE ON DIRECTORY
    ext_data_dir TO ztbd;

CREATE TABLE google_playstore_ext (
    app_name VARCHAR2(255),
    category_name VARCHAR2(64),
    rating_value NUMBER(2,1),
    rating_count NUMBER,
    installs NUMBER(16),
    min_installs NUMBER(16),
    max_installs NUMBER(16),
    free CHAR(1),
    price NUMBER(10),
    currency_name VARCHAR2(16),
    app_size NUMBER,
    min_android VARCHAR2(64),
    developer_name VARCHAR2(255),
    developer_website VARCHAR2(255),
    developer_email VARCHAR2(255),
    released DATE,
    last_updated DATE,
    content_rating NUMBER,
    privacy_policy VARCHAR2(255),
    ad_supported CHAR(1),
    in_app_purchases CHAR(1),
    editor_choice CHAR(1)
)
ORGANIZATION EXTERNAL
(
    TYPE ORACLE_LOADER
    DEFAULT DIRECTORY ext_data_dir
    ACCESS PARAMETERS
    (
        RECORDS DELIMITED BY NEWLINE
        SKIP 1  -- Skip header row
        FIELDS TERMINATED BY ',' OPTIONALLY ENCLOSED BY '"'
        MISSING FIELD VALUES ARE NULL
    )
    LOCATION ('Google-Playstore_cleaned.csv')
)
REJECT LIMIT UNLIMITED; --unlimited number of errors while loading data


