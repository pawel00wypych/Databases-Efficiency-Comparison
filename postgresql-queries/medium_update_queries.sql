\pset pager off

DO $$
DECLARE
    v_start_time TIMESTAMP;
    v_end_time TIMESTAMP;
    v_elapsed_time INTERVAL;
    v_rowcount INTEGER;
BEGIN

    v_start_time := clock_timestamp();
    WITH to_update AS (
        SELECT a.ctid
        FROM Application a
        JOIN Rating r ON a.app_id = r.app_id
        JOIN Install_History ih ON a.app_id = ih.app_id
        WHERE r.rating_value >= 3.0 AND ih.installs >= 1000
        LIMIT 10000
    )
    UPDATE Application a
    SET price = ROUND(COALESCE(price, 0) * 1.5, 2)
    WHERE a.ctid IN (SELECT ctid FROM to_update);
    GET DIAGNOSTICS v_rowcount = ROW_COUNT;
    v_end_time := clock_timestamp();
    v_elapsed_time := v_end_time - v_start_time;
    RAISE NOTICE 'Updated % rows in %', v_rowcount, v_elapsed_time;

    ROLLBACK;

    v_start_time := clock_timestamp();
    WITH to_update AS (
        SELECT a.ctid
        FROM Application a
        JOIN Rating r ON a.app_id = r.app_id
        JOIN Install_History ih ON a.app_id = ih.app_id
        WHERE r.rating_value >= 3.0 AND ih.installs >= 1000
        LIMIT 100000
    )
    UPDATE Application a
    SET price = ROUND(COALESCE(price, 0) * 1.5, 2)
    WHERE a.ctid IN (SELECT ctid FROM to_update);
    GET DIAGNOSTICS v_rowcount = ROW_COUNT;
    v_end_time := clock_timestamp();
    v_elapsed_time := v_end_time - v_start_time;
    RAISE NOTICE 'Updated % rows in %', v_rowcount, v_elapsed_time;

    ROLLBACK;

    v_start_time := clock_timestamp();
    WITH to_update AS (
        SELECT a.ctid
        FROM Application a
        JOIN Rating r ON a.app_id = r.app_id
        JOIN Install_History ih ON a.app_id = ih.app_id
        WHERE r.rating_value >= 3.0 AND ih.installs >= 1000
        LIMIT 500000
    )
    UPDATE Application a
    SET price = ROUND(COALESCE(price, 0) * 1.5, 2)
    WHERE a.ctid IN (SELECT ctid FROM to_update);
    GET DIAGNOSTICS v_rowcount = ROW_COUNT;
    v_end_time := clock_timestamp();
    v_elapsed_time := v_end_time - v_start_time;
    RAISE NOTICE 'Updated % rows in %', v_rowcount, v_elapsed_time;

    ROLLBACK;

    v_start_time := clock_timestamp();
    WITH to_update AS (
        SELECT a.ctid
        FROM Application a
        JOIN Rating r ON a.app_id = r.app_id
        JOIN Install_History ih ON a.app_id = ih.app_id
        WHERE r.rating_value >= 3.0 AND ih.installs >= 1000
        LIMIT 1000000
    )
    UPDATE Application a
    SET price = ROUND(COALESCE(price, 0) * 1.5, 2)
    WHERE a.ctid IN (SELECT ctid FROM to_update);
    GET DIAGNOSTICS v_rowcount = ROW_COUNT;
    v_end_time := clock_timestamp();
    v_elapsed_time := v_end_time - v_start_time;
    RAISE NOTICE 'Updated % rows in %', v_rowcount, v_elapsed_time;

    ROLLBACK;

END;
$$;