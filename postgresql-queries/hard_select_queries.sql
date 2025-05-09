\pset pager off

DO $$
DECLARE
    v_start_time TIMESTAMP;
    v_end_time TIMESTAMP;
    v_elapsed_time INTERVAL;
    v_rowcount INTEGER;
    rec RECORD;
BEGIN

    v_rowcount := 0;
    v_start_time := clock_timestamp();
    FOR rec IN
        SELECT d.developer_name, a.app_id, i.installs,
               COUNT(a.app_id) AS app_count,
               SUM(i.installs) AS total_installs
        FROM application a
        JOIN developer d ON a.developer_id = d.developer_id
        JOIN install_history i ON a.app_id = i.app_id
        CROSS JOIN generate_series(1, 10) AS n
        GROUP BY d.developer_name, a.app_id, i.installs
        HAVING COUNT(a.app_id) > 1
        LIMIT 10000
    LOOP
        v_rowcount := v_rowcount + 1;
    END LOOP;

    v_end_time := clock_timestamp();
    v_elapsed_time := v_end_time - v_start_time;
    RAISE NOTICE 'Selected % rows in %', v_rowcount, v_elapsed_time;

    v_rowcount := 0;
    v_start_time := clock_timestamp();
    FOR rec IN
        SELECT d.developer_name, a.app_id, i.installs,
               COUNT(a.app_id) AS app_count,
               SUM(i.installs) AS total_installs
        FROM application a
        JOIN developer d ON a.developer_id = d.developer_id
        JOIN install_history i ON a.app_id = i.app_id
        CROSS JOIN generate_series(1, 10) AS n
        GROUP BY d.developer_name, a.app_id, i.installs
        HAVING COUNT(a.app_id) > 1
        LIMIT 100000
    LOOP
        v_rowcount := v_rowcount + 1;
    END LOOP;

    v_end_time := clock_timestamp();
    v_elapsed_time := v_end_time - v_start_time;
    RAISE NOTICE 'Selected % rows in %', v_rowcount, v_elapsed_time;

    v_rowcount := 0;
    v_start_time := clock_timestamp();
    FOR rec IN
        SELECT d.developer_name, a.app_id, i.installs,
               COUNT(a.app_id) AS app_count,
               SUM(i.installs) AS total_installs
        FROM application a
        JOIN developer d ON a.developer_id = d.developer_id
        JOIN install_history i ON a.app_id = i.app_id
        CROSS JOIN generate_series(1, 10) AS n
        GROUP BY d.developer_name, a.app_id, i.installs
        HAVING COUNT(a.app_id) > 1
        LIMIT 500000
    LOOP
        v_rowcount := v_rowcount + 1;
    END LOOP;

    v_end_time := clock_timestamp();
    v_elapsed_time := v_end_time - v_start_time;
    RAISE NOTICE 'Selected % rows in %', v_rowcount, v_elapsed_time;

    v_rowcount := 0;
    v_start_time := clock_timestamp();
    FOR rec IN
        SELECT d.developer_name, a.app_id, i.installs,
               COUNT(a.app_id) AS app_count,
               SUM(i.installs) AS total_installs
        FROM application a
        JOIN developer d ON a.developer_id = d.developer_id
        JOIN install_history i ON a.app_id = i.app_id
        CROSS JOIN generate_series(1, 10) AS n
        GROUP BY d.developer_name, a.app_id, i.installs
        HAVING COUNT(a.app_id) > 1
        LIMIT 1000000
    LOOP
        v_rowcount := v_rowcount + 1;
    END LOOP;

    v_end_time := clock_timestamp();
    v_elapsed_time := v_end_time - v_start_time;
    RAISE NOTICE 'Selected % rows in %', v_rowcount, v_elapsed_time;

END;
$$;
