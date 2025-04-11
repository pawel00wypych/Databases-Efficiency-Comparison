-- Drop user if exists (prevents errors on re-runs)
DO $$
BEGIN
    IF EXISTS (SELECT 1 FROM pg_roles WHERE rolname = 'ztbd') THEN
        EXECUTE 'DROP ROLE ztbd';
    END IF;
END;
$$;
-- Create the new user (this will run after dropping)
DO $$
BEGIN
    IF NOT EXISTS (SELECT 1 FROM pg_roles WHERE rolname = 'ztbd') THEN
        EXECUTE 'CREATE USER ztbd WITH PASSWORD ''password''';
    END IF;
END;
$$;

-- Grant permissions to user
GRANT CONNECT, CREATE, TEMPORARY, EXECUTE TO ztbd;
ALTER ROLE ztbd SET search_path TO public;


-- Switch to the new user
SET search_path TO ztbd;

DROP TABLE IF EXISTS staging_table;

-- Create staging table to load data from csv fast
CREATE TEMPORARY TABLE staging_table (
    app_name VARCHAR(255),
    app_address VARCHAR(255),
    category_name VARCHAR(64),
    rating_value NUMERIC(2,1),
    rating_count INTEGER,
    installs BIGINT,
    minimum_installs BIGINT,
    maximum_installs BIGINT,
    free CHAR(1),
    price NUMERIC(10),
    currency_name VARCHAR(16),
    app_size NUMERIC,
    version VARCHAR(64),
    developer_name VARCHAR(255),
    developer_website VARCHAR(1000),
    developer_email VARCHAR(255),
    released DATE,
    last_updated DATE,
    rating_name VARCHAR(64),
    privacy_policy VARCHAR(1000),
    ad_supported CHAR(1),
    in_app_purchases CHAR(1)
);

CREATE TABLE Currency (
    currency_id INTEGER GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    currency_name VARCHAR(16)
);

CREATE TABLE Developer (
    developer_id INTEGER GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    developer_name VARCHAR(255),
    developer_website VARCHAR(1000),
    developer_email VARCHAR(255)
);

CREATE TABLE Content_Rating (
    content_rating_id INTEGER GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    rating_name VARCHAR(64)
);

CREATE TABLE Minimum_Android (
    android_id INTEGER GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    version VARCHAR(64)
);

-- Create the dependent tables that reference the above tables
CREATE TABLE Application (
    app_id INTEGER GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    app_name VARCHAR(255),
    app_address VARCHAR(255),
    free CHAR(1),
    price NUMERIC(10),
    currency_id INTEGER REFERENCES Currency(currency_id),
    app_size NUMERIC,
    developer_id INTEGER REFERENCES Developer(developer_id),
    android_id INTEGER REFERENCES Minimum_Android(android_id),
    released DATE,
    privacy_policy VARCHAR(1000),
    last_updated DATE,
    content_rating_id INTEGER REFERENCES Content_Rating(content_rating_id),
    ad_supported CHAR(1),
    in_app_purchases CHAR(1)
);

CREATE TABLE Category (
    category_id INTEGER GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    category_name VARCHAR(64)
);

CREATE TABLE Application_Category (
    app_id INTEGER REFERENCES Application(app_id) ON DELETE CASCADE,
    category_id INTEGER REFERENCES Category(category_id),
    PRIMARY KEY (app_id, category_id)
);

CREATE TABLE Rating (
    rating_id INTEGER GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    app_id INTEGER REFERENCES Application(app_id) ON DELETE CASCADE,
    rating_value NUMERIC(2,1),
    rating_count INTEGER
);

CREATE TABLE Install_History (
    install_id INTEGER GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    app_id INTEGER REFERENCES Application(app_id) ON DELETE CASCADE,
    installs BIGINT,
    minimum_installs BIGINT,
    maximum_installs BIGINT
);