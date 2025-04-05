-- BEGIN TRANSACTION
SET DEFINE OFF;
SET SERVEROUTPUT ON;

-- Declare variables for execution time and inserted row count
DECLARE
    v_start_time   TIMESTAMP;
    v_end_time     TIMESTAMP;
    v_elapsed_time INTERVAL DAY TO SECOND;
    v_inserted_rows NUMBER := 0;
BEGIN
    -- Record the start time
    v_start_time := SYSTIMESTAMP;

    -- Create indexes using EXECUTE IMMEDIATE
    EXECUTE IMMEDIATE 'CREATE INDEX idx_app_name_address ON Application(app_name, app_address)';
    EXECUTE IMMEDIATE 'CREATE INDEX idx_currency_name ON Currency(currency_name)';
    EXECUTE IMMEDIATE 'CREATE INDEX idx_rating_name ON Content_Rating(rating_name)';
    EXECUTE IMMEDIATE 'CREATE INDEX idx_category_name ON Category(category_name)';
    EXECUTE IMMEDIATE 'CREATE INDEX idx_version ON Minimum_Android(version)';
    EXECUTE IMMEDIATE 'CREATE INDEX idx_dev_composite ON Developer(developer_name, developer_website, developer_email)';

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

    -- Display the start time, end time, and elapsed time
    DBMS_OUTPUT.PUT_LINE('Time start: ' || TO_CHAR(v_start_time, 'DD-MON-YYYY HH24:MI:SS.FF'));
    DBMS_OUTPUT.PUT_LINE('Time finished: ' || TO_CHAR(v_end_time, 'DD-MON-YYYY HH24:MI:SS.FF'));
    DBMS_OUTPUT.PUT_LINE('Elapsed time: ' || TO_CHAR(v_elapsed_time, 'HH24:MI:SS.FF'));
    DBMS_OUTPUT.PUT_LINE('Total Rows Inserted: ' || v_inserted_rows);
END;
/