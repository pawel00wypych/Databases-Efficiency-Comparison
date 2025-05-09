-- Utwórz użytkownika ztbd, jeśli nie istnieje
DO $$
BEGIN
    IF NOT EXISTS (SELECT 1 FROM pg_roles WHERE rolname = 'ztbd') THEN
        EXECUTE 'CREATE USER ztbd WITH PASSWORD ''ztbd''';
    END IF;
END;
$$;


-- Utwórz schemat, jeśli nie istnieje
CREATE SCHEMA IF NOT EXISTS ztbd AUTHORIZATION ztbd;

GRANT CONNECT, TEMPORARY ON DATABASE mydatabase TO ztbd;
GRANT USAGE, CREATE ON SCHEMA ztbd TO ztbd;



-- Użyj schematu ztbd
ALTER ROLE ztbd SET search_path TO ztbd, public;

-- Tworzenie tabel (najpierw staging)
DROP TABLE IF EXISTS staging_table;
CREATE TABLE staging_table (
    app_name VARCHAR(255),
    app_address VARCHAR(255),
    category_name VARCHAR(64),
    rating_value NUMERIC(2,1),
    rating_count NUMERIC,
    installs NUMERIC,
    minimum_installs NUMERIC,
    maximum_installs NUMERIC,
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
    privacy_policy TEXT,
    ad_supported CHAR(1),
    in_app_purchases CHAR(1)
);

-- Pozostałe tabele
CREATE TABLE IF NOT EXISTS Currency (
    currency_id INTEGER GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    currency_name VARCHAR(16)
);

CREATE TABLE IF NOT EXISTS Developer (
    developer_id INTEGER GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    developer_name VARCHAR(255),
    developer_website VARCHAR(1000),
    developer_email VARCHAR(255)
);

CREATE TABLE IF NOT EXISTS Content_Rating (
    content_rating_id INTEGER GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    rating_name VARCHAR(64)
);

CREATE TABLE IF NOT EXISTS Minimum_Android (
    android_id INTEGER GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    version VARCHAR(64)
);

CREATE TABLE IF NOT EXISTS Application (
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
    privacy_policy TEXT,
    last_updated DATE,
    content_rating_id INTEGER REFERENCES Content_Rating(content_rating_id),
    ad_supported CHAR(1),
    in_app_purchases CHAR(1)
);

CREATE TABLE IF NOT EXISTS Category (
    category_id INTEGER GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    category_name VARCHAR(64)
);

CREATE TABLE IF NOT EXISTS Application_Category (
    app_id INTEGER REFERENCES Application(app_id) ON DELETE CASCADE,
    category_id INTEGER REFERENCES Category(category_id),
    PRIMARY KEY (app_id, category_id)
);

CREATE TABLE IF NOT EXISTS Rating (
    rating_id INTEGER GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    app_id INTEGER REFERENCES Application(app_id) ON DELETE CASCADE,
    rating_value NUMERIC(2,1),
    rating_count NUMERIC
);

CREATE TABLE IF NOT EXISTS Install_History (
    install_id INTEGER GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    app_id INTEGER REFERENCES Application(app_id) ON DELETE CASCADE,
    installs NUMERIC,
    minimum_installs NUMERIC,
    maximum_installs NUMERIC
);