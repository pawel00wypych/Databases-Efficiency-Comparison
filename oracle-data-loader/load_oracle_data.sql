-- BEGIN TRANSACTION
SET DEFINE OFF;
SET SERVEROUTPUT ON;

-- Declare variables for execution time and inserted row count
DECLARE
    v_start_time   TIMESTAMP;
    v_end_time     TIMESTAMP;
    v_elapsed_time INTERVAL DAY TO SECOND;
    v_elapsed_time_total NUMBER := 0; -- Accumulate time in seconds
    v_avg_seconds NUMBER;
    v_hours NUMBER;
    v_minutes NUMBER;
    v_seconds NUMBER;
    v_inserted_rows NUMBER := 0;
    v_index_exists NUMBER := 0;
    v_run_count NUMBER := 1;  -- Number of iterations
BEGIN
    FOR i IN 1..v_run_count LOOP
        -- Record the start time
        v_inserted_rows := 0;

        -- Disable foreign key constraints
        BEGIN
            -- Loop through all foreign keys in the current schema and disable them
            FOR fk IN (
                SELECT constraint_name, table_name
                FROM user_constraints
                WHERE constraint_type = 'R'
            ) LOOP
                EXECUTE IMMEDIATE 'ALTER TABLE ' || fk.table_name || ' DISABLE CONSTRAINT ' || fk.constraint_name;
                DBMS_OUTPUT.PUT_LINE('Disabled foreign key: ' || fk.constraint_name || ' on table: ' || fk.table_name);
            END LOOP;
        END;

        -- Clear existing data from tables
        BEGIN
            -- Truncate the tables to clear old data
            EXECUTE IMMEDIATE 'TRUNCATE TABLE Application';
            EXECUTE IMMEDIATE 'TRUNCATE TABLE Application_Category';
            EXECUTE IMMEDIATE 'TRUNCATE TABLE Content_Rating';
            EXECUTE IMMEDIATE 'TRUNCATE TABLE Category';
            EXECUTE IMMEDIATE 'TRUNCATE TABLE Currency';
            EXECUTE IMMEDIATE 'TRUNCATE TABLE Developer';
            EXECUTE IMMEDIATE 'TRUNCATE TABLE Minimum_Android';
            EXECUTE IMMEDIATE 'TRUNCATE TABLE Rating';
            EXECUTE IMMEDIATE 'TRUNCATE TABLE Install_History';
        END;

        BEGIN
            -- Loop through all foreign keys in the current schema and enable them
            FOR fk IN (
                SELECT constraint_name, table_name
                FROM user_constraints
                WHERE constraint_type = 'R'
            ) LOOP
                EXECUTE IMMEDIATE 'ALTER TABLE ' || fk.table_name || ' ENABLE CONSTRAINT ' || fk.constraint_name;
                DBMS_OUTPUT.PUT_LINE('Enabled foreign key: ' || fk.constraint_name || ' on table: ' || fk.table_name);
            END LOOP;
        END;


         -- Check if index exists and create it if it doesn't
        BEGIN
            -- Check for index idx_app_name_address
            SELECT COUNT(*) INTO v_index_exists
            FROM user_indexes
            WHERE index_name = 'IDX_APP_NAME_ADDRESS';

            IF v_index_exists = 0 THEN
                EXECUTE IMMEDIATE 'CREATE INDEX idx_app_name_address ON Application(app_name, app_address)';
                EXECUTE IMMEDIATE 'CREATE INDEX idx_currency_name ON Currency(currency_name)';
                EXECUTE IMMEDIATE 'CREATE INDEX idx_rating_name ON Content_Rating(rating_name)';
                EXECUTE IMMEDIATE 'CREATE INDEX idx_category_name ON Category(category_name)';
                EXECUTE IMMEDIATE 'CREATE INDEX idx_version ON Minimum_Android(version)';
                EXECUTE IMMEDIATE 'CREATE INDEX idx_dev_composite ON Developer(developer_name, developer_website, developer_email)';
            ELSE
                DBMS_OUTPUT.PUT_LINE('Indexes already exist. Skipping creation.');
            END IF;
        END;

        v_start_time := SYSTIMESTAMP;

        -- 1. Insert into lookup tables (deduplicated)
        INSERT INTO Currency (currency_name)
        SELECT DISTINCT currency_name
        FROM staging_table s
        WHERE currency_name IS NOT NULL
          AND NOT EXISTS (
            SELECT 1 FROM Currency c WHERE c.currency_name = s.currency_name
        );
        v_inserted_rows := v_inserted_rows + SQL%ROWCOUNT;

        INSERT INTO Developer (developer_name, developer_website, developer_email)
        SELECT DISTINCT developer_name, developer_website, developer_email
        FROM staging_table s
        WHERE developer_name IS NOT NULL
          AND NOT EXISTS (
            SELECT 1 FROM Developer d
            WHERE d.developer_name = s.developer_name
              AND d.developer_website = s.developer_website
              AND d.developer_email = s.developer_email
        );
        v_inserted_rows := v_inserted_rows + SQL%ROWCOUNT;

        INSERT INTO Content_Rating (rating_name)
        SELECT DISTINCT rating_name
        FROM staging_table s
        WHERE rating_name IS NOT NULL
          AND NOT EXISTS (
            SELECT 1 FROM Content_Rating cr WHERE cr.rating_name = s.rating_name
        );
        v_inserted_rows := v_inserted_rows + SQL%ROWCOUNT;

        INSERT INTO Category (category_name)
        SELECT DISTINCT category_name
        FROM staging_table s
        WHERE category_name IS NOT NULL
          AND NOT EXISTS (
            SELECT 1 FROM Category cat WHERE cat.category_name = s.category_name
        );
        v_inserted_rows := v_inserted_rows + SQL%ROWCOUNT;

        INSERT INTO Minimum_Android (version)
        SELECT DISTINCT version
        FROM staging_table s
        WHERE version IS NOT NULL
          AND NOT EXISTS (
            SELECT 1 FROM Minimum_Android andro WHERE andro.version = s.version
        );
        v_inserted_rows := v_inserted_rows + SQL%ROWCOUNT;

        -- 2. Insert into Application table
        INSERT INTO Application (
            app_name, app_address, free, price, currency_id,
            app_size, developer_id, android_id, released, privacy_policy,
            last_updated, content_rating_id, ad_supported,
            in_app_purchases
        )
        SELECT
            s.app_name,
            s.app_address,
            s.free,
            s.price,
            c.currency_id,
            s.app_size,
            d.developer_id,
            mand.android_id,
            s.released,
            s.privacy_policy,
            s.last_updated,
            cr.content_rating_id,
            s.ad_supported,
            s.in_app_purchases
        FROM staging_table s
        JOIN Currency c ON s.currency_name = c.currency_name
        JOIN Developer d ON s.developer_name = d.developer_name
                        AND s.developer_website = d.developer_website
                        AND s.developer_email = d.developer_email
        JOIN Content_Rating cr ON s.rating_name = cr.rating_name
        JOIN Minimum_Android mand ON s.version = mand.version
        WHERE NOT EXISTS (
            SELECT 1 FROM Application a
            WHERE a.app_name = s.app_name AND a.app_address = s.app_address
        );
        v_inserted_rows := v_inserted_rows + SQL%ROWCOUNT;

        -- 3. Insert into Application_Category
        INSERT INTO Application_Category (app_id, category_id)
        SELECT
            a.app_id,
            cat.category_id
        FROM staging_table s
        JOIN Application a ON s.app_name = a.app_name AND s.app_address = a.app_address
        JOIN Category cat ON s.category_name = cat.category_name
        WHERE NOT EXISTS (
            SELECT 1 FROM Application_Category ac
            WHERE ac.app_id = a.app_id AND ac.category_id = cat.category_id
        );
        v_inserted_rows := v_inserted_rows + SQL%ROWCOUNT;

        -- 4. Insert into Rating
        INSERT INTO Rating (app_id, rating_value, rating_count)
        SELECT
            a.app_id,
            s.rating_value,
            s.rating_count
        FROM staging_table s
        JOIN Application a ON s.app_name = a.app_name AND s.app_address = a.app_address;
        v_inserted_rows := v_inserted_rows + SQL%ROWCOUNT;

        -- 5. Insert into Install_History
        INSERT INTO Install_History (app_id, installs, minimum_installs, maximum_installs)
        SELECT
            a.app_id,
            s.installs,
            s.minimum_installs,
            s.maximum_installs
        FROM staging_table s
        JOIN Application a ON s.app_name = a.app_name AND s.app_address = a.app_address;
        v_inserted_rows := v_inserted_rows + SQL%ROWCOUNT;

        -- COMMIT CHANGES
        COMMIT;

        -- Record the end time
        v_end_time := SYSTIMESTAMP;

        v_elapsed_time := v_end_time - v_start_time;
        v_elapsed_time_total := v_elapsed_time_total + EXTRACT(SECOND FROM v_elapsed_time) +
                                EXTRACT(MINUTE FROM v_elapsed_time) * 60 +
                                EXTRACT(HOUR FROM v_elapsed_time) * 3600;

        -- Display the start time, end time, and elapsed time
        DBMS_OUTPUT.PUT_LINE('Time start: ' || TO_CHAR(v_start_time, 'HH24:MI:SS.FF'));
        DBMS_OUTPUT.PUT_LINE('Time finished: ' || TO_CHAR(v_end_time, 'HH24:MI:SS.FF'));
        DBMS_OUTPUT.PUT_LINE('Elapsed time: ' || TO_CHAR(v_elapsed_time, 'HH24:MI:SS.FF'));
        DBMS_OUTPUT.PUT_LINE('Total Rows Inserted: ' || v_inserted_rows);

     END LOOP;

    v_avg_seconds := v_elapsed_time_total / v_run_count;

    -- Calculate and display the total execution time in HH:MI:SS format
    v_hours := FLOOR(v_elapsed_time_total / 3600);
    v_minutes := FLOOR((v_elapsed_time_total - v_hours * 3600) / 60);
    v_seconds := v_elapsed_time_total - (v_hours * 3600 + v_minutes * 60);

    DBMS_OUTPUT.PUT_LINE('Total Execution Time: ' || TO_CHAR(v_hours, 'FM00') || ':' || TO_CHAR(v_minutes, 'FM00') || ':' || TO_CHAR(v_seconds, 'FM00'));

    -- Calculate and display the average execution time in HH:MI:SS format
    v_hours := FLOOR(v_avg_seconds / 3600);
    v_minutes := FLOOR((v_avg_seconds - v_hours * 3600) / 60);
    v_seconds := v_avg_seconds - (v_hours * 3600 + v_minutes * 60);

    DBMS_OUTPUT.PUT_LINE('Average Execution Time: ' || TO_CHAR(v_hours, 'FM00') || ':' || TO_CHAR(v_minutes, 'FM00') || ':' || TO_CHAR(v_seconds, 'FM00'));
    DBMS_OUTPUT.PUT_LINE('Number of executions: ' || TO_CHAR(v_run_count));
END;
/