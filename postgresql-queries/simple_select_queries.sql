\pset pager off

DO $$
DECLARE
    v_start_time TIMESTAMP;
    v_end_time TIMESTAMP;
    v_elapsed_time INTERVAL;
    v_rowcount INTEGER;
BEGIN

    v_start_time := clock_timestamp();
    PERFORM app_name, app_address, app_size
    FROM application
    LIMIT 10000;
    GET DIAGNOSTICS v_rowcount = ROW_COUNT;
    v_end_time := clock_timestamp();
    v_elapsed_time := v_end_time - v_start_time;
    RAISE NOTICE 'Selected % rows in %', v_rowcount, v_elapsed_time;

    v_start_time := clock_timestamp();
    PERFORM app_name, app_address, app_size
    FROM application
    LIMIT 100000;
    GET DIAGNOSTICS v_rowcount = ROW_COUNT;
    v_end_time := clock_timestamp();
    v_elapsed_time := v_end_time - v_start_time;
    RAISE NOTICE 'Selected % rows in %', v_rowcount, v_elapsed_time;

    v_start_time := clock_timestamp();
    PERFORM app_name, app_address, app_size
    FROM application
    LIMIT 500000;
    GET DIAGNOSTICS v_rowcount = ROW_COUNT;
    v_end_time := clock_timestamp();
    v_elapsed_time := v_end_time - v_start_time;
    RAISE NOTICE 'Selected % rows in %', v_rowcount, v_elapsed_time;

    v_start_time := clock_timestamp();
    PERFORM app_name, app_address, app_size
    FROM application
    CROSS JOIN generate_series(1, 5) AS n
    LIMIT 1000000;
    GET DIAGNOSTICS v_rowcount = ROW_COUNT;
    v_end_time := clock_timestamp();
    v_elapsed_time := v_end_time - v_start_time;
    RAISE NOTICE 'Selected % rows in %', v_rowcount, v_elapsed_time;

END;
$$;
