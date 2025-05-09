\pset pager off

DO $$
DECLARE
    v_start_time TIMESTAMP;
    v_end_time TIMESTAMP;
    v_elapsed_time INTERVAL;
    v_rowcount INTEGER;
BEGIN

    v_start_time := clock_timestamp();
    PERFORM a.app_name, d.developer_name, r.rating_value
    FROM application a
    JOIN developer d ON a.developer_id = d.developer_id
    JOIN rating r ON a.app_id = r.app_id
    LIMIT 10000;
    GET DIAGNOSTICS v_rowcount = ROW_COUNT;
    v_end_time := clock_timestamp();
    v_elapsed_time := v_end_time - v_start_time;
    RAISE NOTICE 'Selected % rows in %', v_rowcount, v_elapsed_time;

    v_start_time := clock_timestamp();
    PERFORM a.app_name, d.developer_name, r.rating_value
    FROM application a
    JOIN developer d ON a.developer_id = d.developer_id
    JOIN rating r ON a.app_id = r.app_id
    LIMIT 100000;
    GET DIAGNOSTICS v_rowcount = ROW_COUNT;
    v_end_time := clock_timestamp();
    v_elapsed_time := v_end_time - v_start_time;
    RAISE NOTICE 'Selected % rows in %', v_rowcount, v_elapsed_time;

    v_start_time := clock_timestamp();
    PERFORM a.app_name, d.developer_name, r.rating_value
    FROM application a
    JOIN developer d ON a.developer_id = d.developer_id
    JOIN rating r ON a.app_id = r.app_id
    CROSS JOIN generate_series(1, 10) AS n
    LIMIT 500000;
    GET DIAGNOSTICS v_rowcount = ROW_COUNT;
    v_end_time := clock_timestamp();
    v_elapsed_time := v_end_time - v_start_time;
    RAISE NOTICE 'Selected % rows in %', v_rowcount, v_elapsed_time;

    v_start_time := clock_timestamp();
    PERFORM a.app_name, d.developer_name, r.rating_value
    FROM application a
    JOIN developer d ON a.developer_id = d.developer_id
    JOIN rating r ON a.app_id = r.app_id
    CROSS JOIN generate_series(1, 10) AS n
    LIMIT 1000000;
    GET DIAGNOSTICS v_rowcount = ROW_COUNT;
    v_end_time := clock_timestamp();
    v_elapsed_time := v_end_time - v_start_time;
    RAISE NOTICE 'Selected % rows in %', v_rowcount, v_elapsed_time;

END;
$$;
