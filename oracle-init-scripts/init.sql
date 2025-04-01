-- Drop user if exists (prevents errors on re-runs)
BEGIN
    EXECUTE IMMEDIATE 'DROP USER ztbd CASCADE';
EXCEPTION
    WHEN OTHERS THEN NULL;  -- Ignore errors if user doesn't exist
END;
/

-- Create the new user (this will run after dropping)
BEGIN
    EXECUTE IMMEDIATE 'CREATE USER ztbd IDENTIFIED BY password';
EXCEPTION
    WHEN OTHERS THEN NULL;  -- Ignore errors if user already exists
END;
/

-- Grant permissions to user
GRANT CONNECT, RESOURCE TO ztbd;
ALTER USER ztbd QUOTA UNLIMITED ON USERS;
GRANT CREATE ANY DIRECTORY TO ztbd;
GRANT READ, WRITE ON DIRECTORY data_dir TO ztbd;

CREATE OR REPLACE DIRECTORY data_dir AS '/shared-data';
GRANT READ, WRITE ON DIRECTORY data_dir TO ztbd;

-- Switch to the new user
ALTER SESSION SET CURRENT_SCHEMA = ztbd;


-- First, create the independent tables: Currency, Developer, Content_Rating
CREATE TABLE Currency (
    currency_id NUMBER GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    currency_name VARCHAR2(255),
    symbol VARCHAR2(10)
);

CREATE TABLE Developer (
    developer_id NUMBER GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    developer_name VARCHAR2(255),
    developer_website VARCHAR2(255),
    developer_email VARCHAR2(255)
);

CREATE TABLE Content_Rating (
    content_rating_id NUMBER GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    rating_name VARCHAR2(255)
);

-- Now, create the dependent tables that reference the above tables

CREATE TABLE Application (
    app_id NUMBER GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    app_name VARCHAR2(255),
    free CHAR(1),
    price NUMBER,
    currency_id NUMBER,
    "size" NUMBER,
    developer_id NUMBER,
    released DATE,
    privacy_policy CLOB,
    last_updated DATE,
    content_rating_id NUMBER,
    ad_supported CHAR(1),
    in_app_purchases CHAR(1),
    editor_choice CHAR(1),
    FOREIGN KEY (currency_id) REFERENCES Currency(currency_id),
    FOREIGN KEY (developer_id) REFERENCES Developer(developer_id),
    FOREIGN KEY (content_rating_id) REFERENCES Content_Rating(content_rating_id)
);

CREATE TABLE Category (
    category_id NUMBER GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    category_name VARCHAR2(255)
);

CREATE TABLE Application_Category (
    app_id NUMBER,
    category_id NUMBER,
    PRIMARY KEY (app_id, category_id),
    FOREIGN KEY (app_id) REFERENCES Application(app_id),
    FOREIGN KEY (category_id) REFERENCES Category(category_id)
);

CREATE TABLE Rating (
    rating_id NUMBER GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    app_id NUMBER,
    rating_value NUMBER,
    rating_date DATE,
    FOREIGN KEY (app_id) REFERENCES Application(app_id)
);

CREATE TABLE Install_History (
    install_id NUMBER GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    app_id NUMBER,
    date_recorded DATE,
    installs NUMBER(38,0),
    FOREIGN KEY (app_id) REFERENCES Application(app_id)
);

CREATE TABLE Minimum_Android (
    android_id NUMBER GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    version VARCHAR2(50)
);
