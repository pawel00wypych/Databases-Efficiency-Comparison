\pset pager off

DO $$
DECLARE
    v_start_time TIMESTAMP;
    v_end_time TIMESTAMP;
    v_elapsed_time INTERVAL;
    v_rowcount INTEGER;
BEGIN

    v_start_time := clock_timestamp();
    DELETE FROM Application
    WHERE ctid IN (
        SELECT ctid FROM Application
        WHERE price >= 0
        LIMIT 10000
    );
    GET DIAGNOSTICS v_rowcount = ROW_COUNT;
    v_end_time := clock_timestamp();
    v_elapsed_time := v_end_time - v_start_time;
    RAISE NOTICE 'Deleted % rows in %', v_rowcount, v_elapsed_time;
    ROLLBACK;


    v_start_time := clock_timestamp();
    DELETE FROM Application
    WHERE ctid IN (
        SELECT ctid FROM Application
        WHERE price >= 0
        LIMIT 100000
    );
    GET DIAGNOSTICS v_rowcount = ROW_COUNT;
    v_end_time := clock_timestamp();
    v_elapsed_time := v_end_time - v_start_time;
    RAISE NOTICE 'Deleted % rows in %', v_rowcount, v_elapsed_time;
    ROLLBACK;

    v_start_time := clock_timestamp();
    DELETE FROM Application
    WHERE ctid IN (
        SELECT ctid FROM Application
        WHERE price >= 0
        LIMIT 500000
    );
    GET DIAGNOSTICS v_rowcount = ROW_COUNT;
    v_end_time := clock_timestamp();
    v_elapsed_time := v_end_time - v_start_time;
    RAISE NOTICE 'Deleted % rows in %', v_rowcount, v_elapsed_time;
    ROLLBACK;

    v_start_time := clock_timestamp();
    DELETE FROM Application
    WHERE ctid IN (
        SELECT ctid FROM Application
        WHERE price >= 0
        LIMIT 1000000
    );
    GET DIAGNOSTICS v_rowcount = ROW_COUNT;
    v_end_time := clock_timestamp();
    v_elapsed_time := v_end_time - v_start_time;
    RAISE NOTICE 'Deleted % rows in %', v_rowcount, v_elapsed_time;
    ROLLBACK;

END;
$$;
