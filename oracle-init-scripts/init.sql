-- Drop user if exists (prevents errors on re-runs)
BEGIN
    EXECUTE IMMEDIATE 'DROP USER ztbd CASCADE';
EXCEPTION
    WHEN OTHERS THEN NULL;  -- Ignore error if user doesn't exist
END;
/
-- Create the new user (this will run after dropping)
BEGIN
    EXECUTE IMMEDIATE 'CREATE USER ztbd IDENTIFIED BY password default tablespace users
                        temporary tablespace temp';
EXCEPTION
    WHEN OTHERS THEN NULL;  -- Ignore errors if user already exists
END;
/

-- Grant permissions to user
GRANT CONNECT, RESOURCE TO ztbd;
ALTER USER ztbd QUOTA UNLIMITED ON USERS;
GRANT CREATE ANY DIRECTORY TO ztbd;
GRANT CREATE TABLE, CREATE VIEW, CREATE PROCEDURE, CREATE SEQUENCE TO ztbd;


-- Switch to the new user
ALTER SESSION SET CURRENT_SCHEMA = ztbd;

-- First, create the independent tables: Currency, Developer, Content_Rating
CREATE TABLE Currency (
    currency_id NUMBER GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    currency_name VARCHAR2(16)
);

CREATE TABLE Developer (
    developer_id NUMBER GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    developer_name VARCHAR2(255),
    developer_website VARCHAR2(255),
    developer_email VARCHAR2(255)
);

CREATE TABLE Content_Rating (
    content_rating_id NUMBER GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    rating_name VARCHAR2(64)
);

-- Create the dependent tables that reference the above tables
CREATE TABLE Application (
    app_id NUMBER GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    app_name VARCHAR2(255),
    free CHAR(1),
    price NUMBER(10),
    currency_id NUMBER,
    app_size NUMBER,
    developer_id NUMBER,
    released DATE,
    privacy_policy VARCHAR2(1024),
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
    category_name VARCHAR2(64)
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
    rating_value NUMBER(2,1),
    rating_count NUMBER,
    FOREIGN KEY (app_id) REFERENCES Application(app_id) ON DELETE CASCADE
);

CREATE TABLE Install_History (
    install_id NUMBER GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    app_id NUMBER,
    installs NUMBER(16),
    minimum_installs NUMBER(16),
    maximum_installs NUMBER(16),
    FOREIGN KEY (app_id) REFERENCES Application(app_id) ON DELETE CASCADE
);

CREATE TABLE Minimum_Android (
    android_id NUMBER GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    version VARCHAR2(64)
);