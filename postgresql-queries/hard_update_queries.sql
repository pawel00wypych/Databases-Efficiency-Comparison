\pset pager off

DO $$
DECLARE
    v_start_time TIMESTAMP;
    v_end_time TIMESTAMP;
    v_elapsed_time INTERVAL;
    v_rowcount INTEGER;
BEGIN

    v_start_time := clock_timestamp();
    UPDATE Application a
    SET
        price = ROUND(
            CASE
                WHEN src.rating_value >= 4.5 THEN COALESCE(a.price, 0)::NUMERIC * 1.15
                WHEN src.rating_value >= 3.0 THEN COALESCE(a.price, 0)::NUMERIC * 1.05
                ELSE COALESCE(a.price, 0)::NUMERIC * 0.95
            END, 2),
        privacy_policy = LOWER(SUBSTRING(a.privacy_policy FROM 1 FOR 100)),
        app_size = CASE
            WHEN a.app_size IS NULL THEN ROUND((random() * 90 + 10)::NUMERIC, 2)
            ELSE a.app_size
        END
    FROM (
        SELECT a2.app_id, r.rating_value, d.developer_email, d.developer_name
        FROM Application a2
        JOIN Rating r ON a2.app_id = r.app_id
        JOIN Install_History ih ON a2.app_id = ih.app_id
        JOIN Developer d ON a2.developer_id = d.developer_id
        WHERE ih.installs >= 1
          AND (r.rating_value >= 3.0 OR d.developer_name ~* '.*hack.*')
        LIMIT 10000
    ) src
    WHERE a.app_id = src.app_id;
    GET DIAGNOSTICS v_rowcount = ROW_COUNT;
    v_end_time := clock_timestamp();
    v_elapsed_time := v_end_time - v_start_time;
    RAISE NOTICE 'Updated % rows in %', v_rowcount, v_elapsed_time;

    ROLLBACK;

    v_start_time := clock_timestamp();
    UPDATE Application a
    SET
        price = ROUND(
            CASE
                WHEN src.rating_value >= 4.5 THEN COALESCE(a.price, 0)::NUMERIC * 1.15
                WHEN src.rating_value >= 3.0 THEN COALESCE(a.price, 0)::NUMERIC * 1.05
                ELSE COALESCE(a.price, 0)::NUMERIC * 0.95
            END, 2),
        privacy_policy = LOWER(SUBSTRING(a.privacy_policy FROM 1 FOR 100)),
        app_size = CASE
            WHEN a.app_size IS NULL THEN ROUND((random() * 90 + 10)::NUMERIC, 2)
            ELSE a.app_size
        END
    FROM (
        SELECT a2.app_id, r.rating_value, d.developer_email, d.developer_name
        FROM Application a2
        JOIN Rating r ON a2.app_id = r.app_id
        JOIN Install_History ih ON a2.app_id = ih.app_id
        JOIN Developer d ON a2.developer_id = d.developer_id
        WHERE ih.installs >= 1
          AND (r.rating_value >= 3.0 OR d.developer_name ~* '.*hack.*')
        LIMIT 100000
    ) src
    WHERE a.app_id = src.app_id;

    GET DIAGNOSTICS v_rowcount = ROW_COUNT;
    v_end_time := clock_timestamp();
    v_elapsed_time := v_end_time - v_start_time;
    RAISE NOTICE 'Updated % rows in %', v_rowcount, v_elapsed_time;

    ROLLBACK;

    v_start_time := clock_timestamp();
    UPDATE Application a
    SET
        price = ROUND(
            CASE
                WHEN src.rating_value >= 4.5 THEN COALESCE(a.price, 0)::NUMERIC * 1.15
                WHEN src.rating_value >= 3.0 THEN COALESCE(a.price, 0)::NUMERIC * 1.05
                ELSE COALESCE(a.price, 0)::NUMERIC * 0.95
            END, 2),
        privacy_policy = LOWER(SUBSTRING(a.privacy_policy FROM 1 FOR 100)),
        app_size = CASE
            WHEN a.app_size IS NULL THEN ROUND((random() * 90 + 10)::NUMERIC, 2)
            ELSE a.app_size
        END
    FROM (
        SELECT a2.app_id, r.rating_value, d.developer_email, d.developer_name
        FROM Application a2
        JOIN Rating r ON a2.app_id = r.app_id
        JOIN Install_History ih ON a2.app_id = ih.app_id
        JOIN Developer d ON a2.developer_id = d.developer_id
        WHERE ih.installs >= 1
          AND (r.rating_value >= 3.0 OR d.developer_name ~* '.*hack.*')
        LIMIT 500000
    ) src
    WHERE a.app_id = src.app_id;
    GET DIAGNOSTICS v_rowcount = ROW_COUNT;
    v_end_time := clock_timestamp();
    v_elapsed_time := v_end_time - v_start_time;
    RAISE NOTICE 'Updated % rows in %', v_rowcount, v_elapsed_time;

    ROLLBACK;

    v_start_time := clock_timestamp();
    UPDATE Application a
    SET
        price = ROUND(
            CASE
                WHEN src.rating_value >= 4.5 THEN COALESCE(a.price, 0)::NUMERIC * 1.15
                WHEN src.rating_value >= 3.0 THEN COALESCE(a.price, 0)::NUMERIC * 1.05
                ELSE COALESCE(a.price, 0)::NUMERIC * 0.95
            END, 2),
        privacy_policy = LOWER(SUBSTRING(a.privacy_policy FROM 1 FOR 100)),
        app_size = CASE
            WHEN a.app_size IS NULL THEN ROUND((random() * 90 + 10)::NUMERIC, 2)
            ELSE a.app_size
        END
    FROM (
        SELECT a2.app_id, r.rating_value, d.developer_email, d.developer_name
        FROM Application a2
        JOIN Rating r ON a2.app_id = r.app_id
        JOIN Install_History ih ON a2.app_id = ih.app_id
        JOIN Developer d ON a2.developer_id = d.developer_id
        WHERE ih.installs >= 1
          AND (r.rating_value >= 3.0 OR d.developer_name ~* '.*hack.*')
        LIMIT 1000000
    ) src
    WHERE a.app_id = src.app_id;
    GET DIAGNOSTICS v_rowcount = ROW_COUNT;
    v_end_time := clock_timestamp();
    v_elapsed_time := v_end_time - v_start_time;
    RAISE NOTICE 'Updated % rows in %', v_rowcount, v_elapsed_time;

    ROLLBACK;


END;
$$;