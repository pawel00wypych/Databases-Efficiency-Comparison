\pset pager off

DO $$
DECLARE
    v_start_time TIMESTAMP;
    v_end_time TIMESTAMP;
    v_elapsed_time INTERVAL;
    v_deleted_count INTEGER;
BEGIN

    v_start_time := clock_timestamp();
    DELETE FROM Application a
    USING (
        SELECT a2.app_id
        FROM Application a2
        JOIN Rating r ON a2.app_id = r.app_id
        JOIN Install_History ih ON a2.app_id = ih.app_id
        WHERE r.rating_value < 4
          AND ih.maximum_installs > 1
        LIMIT 10000
    ) sub
    WHERE a.app_id = sub.app_id;
    GET DIAGNOSTICS v_deleted_count = ROW_COUNT;
    v_end_time := clock_timestamp();
    v_elapsed_time := v_end_time - v_start_time;
    RAISE NOTICE 'Deleted % rows in %', v_deleted_count, v_elapsed_time;
    ROLLBACK;

    -- Second batch: DELETE up to 100,000
    v_start_time := clock_timestamp();
    DELETE FROM Application a
    USING (
        SELECT a2.app_id
        FROM Application a2
        JOIN Rating r ON a2.app_id = r.app_id
        JOIN Install_History ih ON a2.app_id = ih.app_id
        WHERE r.rating_value < 4
          AND ih.maximum_installs > 1
        LIMIT 100000
    ) sub
    WHERE a.app_id = sub.app_id;
    GET DIAGNOSTICS v_deleted_count = ROW_COUNT;
    v_end_time := clock_timestamp();
    v_elapsed_time := v_end_time - v_start_time;
    RAISE NOTICE 'Deleted % rows in %', v_deleted_count, v_elapsed_time;
    ROLLBACK;

    -- Third batch: DELETE up to 500,000
    v_start_time := clock_timestamp();
    DELETE FROM Application a
    USING (
        SELECT a2.app_id
        FROM Application a2
        JOIN Rating r ON a2.app_id = r.app_id
        JOIN Install_History ih ON a2.app_id = ih.app_id
        WHERE r.rating_value < 4
          AND ih.maximum_installs > 1
        LIMIT 500000
    ) sub
    WHERE a.app_id = sub.app_id;
    GET DIAGNOSTICS v_deleted_count = ROW_COUNT;
    v_end_time := clock_timestamp();
    v_elapsed_time := v_end_time - v_start_time;
    RAISE NOTICE 'Deleted % rows in %', v_deleted_count, v_elapsed_time;
    ROLLBACK;

    -- Fourth batch: DELETE up to 1,000,000
    v_start_time := clock_timestamp();
    DELETE FROM Application a
    USING (
        SELECT a2.app_id
        FROM Application a2
        JOIN Rating r ON a2.app_id = r.app_id
        JOIN Install_History ih ON a2.app_id = ih.app_id
        WHERE r.rating_value < 4
          AND ih.maximum_installs > 1
        LIMIT 1000000
    ) sub
    WHERE a.app_id = sub.app_id;
    GET DIAGNOSTICS v_deleted_count = ROW_COUNT;
    v_end_time := clock_timestamp();
    v_elapsed_time := v_end_time - v_start_time;
    RAISE NOTICE 'Deleted % rows in %', v_deleted_count, v_elapsed_time;
    ROLLBACK;
END;
$$;
