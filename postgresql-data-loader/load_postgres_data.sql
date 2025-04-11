-- BEGIN TRANSACTION
BEGIN;

-- Start time
DO $$
DECLARE
    v_start_time TIMESTAMP;
    v_end_time TIMESTAMP;
    v_elapsed_time INTERVAL;
    v_start_time_total TIMESTAMP;
    v_end_time_total TIMESTAMP;
    v_elapsed_time_total INTERVAL;
    v_inserted_rows BIGINT := 0;
    v_run_count INTEGER := 5; -- Number of iterations
BEGIN
    v_start_time_total := now();

    FOR i IN 1..v_run_count LOOP
        -- Record the start time
        v_start_time := now();
        v_inserted_rows := 0;

        -- Disable all triggers (foreign keys)
        PERFORM pg_catalog.set_config('session_replication_role', 'replica', true);

        -- Truncate tables
        TRUNCATE TABLE 
            Application_Category,
            Application,
            Content_Rating,
            Category,
            Currency,
            Developer,
            Minimum_Android,
            Rating,
            Install_History
        RESTART IDENTITY CASCADE;

        -- Re-enable triggers
        PERFORM pg_catalog.set_config('session_replication_role', 'origin', true);

        -- Create indexes if they don't exist
        DO $$
        BEGIN
            IF NOT EXISTS (SELECT 1 FROM pg_indexes WHERE indexname = 'idx_app_name_address') THEN
                CREATE INDEX idx_app_name_address ON Application(app_name, app_address);
            END IF;
            IF NOT EXISTS (SELECT 1 FROM pg_indexes WHERE indexname = 'idx_currency_name') THEN
                CREATE INDEX idx_currency_name ON Currency(currency_name);
            END IF;
            IF NOT EXISTS (SELECT 1 FROM pg_indexes WHERE indexname = 'idx_rating_name') THEN
                CREATE INDEX idx_rating_name ON Content_Rating(rating_name);
            END IF;
            IF NOT EXISTS (SELECT 1 FROM pg_indexes WHERE indexname = 'idx_category_name') THEN
                CREATE INDEX idx_category_name ON Category(category_name);
            END IF;
            IF NOT EXISTS (SELECT 1 FROM pg_indexes WHERE indexname = 'idx_version') THEN
                CREATE INDEX idx_version ON Minimum_Android(version);
            END IF;
            IF NOT EXISTS (SELECT 1 FROM pg_indexes WHERE indexname = 'idx_dev_composite') THEN
                CREATE INDEX idx_dev_composite ON Developer(developer_name, developer_website, developer_email);
            END IF;
        END $$;

        -- 1. Insert into lookup tables
        INSERT INTO Currency (currency_name)
        SELECT DISTINCT currency_name
        FROM staging_table
        WHERE currency_name IS NOT NULL
          AND NOT EXISTS (
              SELECT 1 FROM Currency c WHERE c.currency_name = staging_table.currency_name
          );
        GET DIAGNOSTICS v_inserted_rows = v_inserted_rows + ROW_COUNT;

        INSERT INTO Developer (developer_name, developer_website, developer_email)
        SELECT DISTINCT developer_name, developer_website, developer_email
        FROM staging_table
        WHERE developer_name IS NOT NULL
          AND NOT EXISTS (
              SELECT 1 FROM Developer d
              WHERE d.developer_name = staging_table.developer_name
                AND d.developer_website = staging_table.developer_website
                AND d.developer_email = staging_table.developer_email
          );
        GET DIAGNOSTICS v_inserted_rows = v_inserted_rows + ROW_COUNT;

        INSERT INTO Content_Rating (rating_name)
        SELECT DISTINCT rating_name
        FROM staging_table
        WHERE rating_name IS NOT NULL
          AND NOT EXISTS (
              SELECT 1 FROM Content_Rating cr WHERE cr.rating_name = staging_table.rating_name
          );
        GET DIAGNOSTICS v_inserted_rows = v_inserted_rows + ROW_COUNT;

        INSERT INTO Category (category_name)
        SELECT DISTINCT category_name
        FROM staging_table
        WHERE category_name IS NOT NULL
          AND NOT EXISTS (
              SELECT 1 FROM Category cat WHERE cat.category_name = staging_table.category_name
          );
        GET DIAGNOSTICS v_inserted_rows = v_inserted_rows + ROW_COUNT;

        INSERT INTO Minimum_Android (version)
        SELECT DISTINCT version
        FROM staging_table
        WHERE version IS NOT NULL
          AND NOT EXISTS (
              SELECT 1 FROM Minimum_Android ma WHERE ma.version = staging_table.version
          );
        GET DIAGNOSTICS v_inserted_rows = v_inserted_rows + ROW_COUNT;

        -- 2. Insert into Application
        INSERT INTO Application (
            app_name, app_address, free, price, currency_id,
            app_size, developer_id, android_id, released, privacy_policy,
            last_updated, content_rating_id, ad_supported, in_app_purchases
        )
        SELECT
            s.app_name,
            s.app_address,
            s.free,
            s.price,
            c.currency_id,
            s.app_size,
            d.developer_id,
            ma.android_id,
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
        JOIN Minimum_Android ma ON s.version = ma.version
        WHERE NOT EXISTS (
            SELECT 1 FROM Application a
            WHERE a.app_name = s.app_name AND a.app_address = s.app_address
        );
        GET DIAGNOSTICS v_inserted_rows = v_inserted_rows + ROW_COUNT;

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
        GET DIAGNOSTICS v_inserted_rows = v_inserted_rows + ROW_COUNT;

        -- 4. Insert into Rating
        INSERT INTO Rating (app_id, rating_value, rating_count)
        SELECT
            a.app_id,
            s.rating_value,
            s.rating_count
        FROM staging_table s
        JOIN Application a ON s.app_name = a.app_name AND s.app_address = a.app_address;
        GET DIAGNOSTICS v_inserted_rows = v_inserted_rows + ROW_COUNT;

        -- 5. Insert into Install_History
        INSERT INTO Install_History (app_id, installs, minimum_installs, maximum_installs)
        SELECT
            a.app_id,
            s.installs,
            s.minimum_installs,
            s.maximum_installs
        FROM staging_table s
        JOIN Application a ON s.app_name = a.app_name AND s.app_address = a.app_address;
        GET DIAGNOSTICS v_inserted_rows = v_inserted_rows + ROW_COUNT;

        -- Commit
        COMMIT;

        -- Record end time
        v_end_time := now();
        v_elapsed_time := v_end_time - v_start_time;

        RAISE NOTICE 'Time start: %', v_start_time;
        RAISE NOTICE 'Time end: %', v_end_time;
        RAISE NOTICE 'Elapsed time: %', v_elapsed_time;
        RAISE NOTICE 'Total rows inserted this run: %', v_inserted_rows;

    END LOOP;

    v_end_time_total := now();
    v_elapsed_time_total := v_end_time_total - v_start_time_total;

    RAISE NOTICE 'Total Execution Time: %', v_elapsed_time_total;
    RAISE NOTICE 'Average Execution Time: %', v_elapsed_time_total / v_run_count;

END;
$$;
