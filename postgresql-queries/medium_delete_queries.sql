\pset pager off

DO $$
DECLARE
    v_start_time TIMESTAMP;
    v_end_time TIMESTAMP;
    v_elapsed_time INTERVAL;
    v_deleted_count INTEGER;
BEGIN

    v_start_time := clock_timestamp();
    DELETE FROM Application
    WHERE price >= 0
      AND EXISTS (
          SELECT 1
          FROM Rating r
          WHERE r.app_id = Application.app_id
            AND r.rating_value < 3
      )
    AND app_id IN (
        SELECT app_id FROM Application
        WHERE price >= 0
          AND EXISTS (
              SELECT 1
              FROM Rating r
              WHERE r.app_id = Application.app_id
                AND r.rating_value < 3
          )
        LIMIT 10000
    );
    GET DIAGNOSTICS v_deleted_count = ROW_COUNT;
    v_end_time := clock_timestamp();
    v_elapsed_time := v_end_time - v_start_time;
    RAISE NOTICE 'Deleted % rows in %', v_deleted_count, v_elapsed_time;
    ROLLBACK;


    v_start_time := clock_timestamp();
    DELETE FROM Application
    WHERE price >= 0
      AND EXISTS (
          SELECT 1
          FROM Rating r
          WHERE r.app_id = Application.app_id
            AND r.rating_value < 3
      )
    AND app_id IN (
        SELECT app_id FROM Application
        WHERE price >= 0
          AND EXISTS (
              SELECT 1
              FROM Rating r
              WHERE r.app_id = Application.app_id
                AND r.rating_value < 3
          )
        LIMIT 100000
    );
    GET DIAGNOSTICS v_deleted_count = ROW_COUNT;
    v_end_time := clock_timestamp();
    v_elapsed_time := v_end_time - v_start_time;
    RAISE NOTICE 'Deleted % rows in %', v_deleted_count, v_elapsed_time;
    ROLLBACK;


    v_start_time := clock_timestamp();
    DELETE FROM Application
    WHERE price >= 0
      AND EXISTS (
          SELECT 1
          FROM Rating r
          WHERE r.app_id = Application.app_id
            AND r.rating_value < 3
      )
    AND app_id IN (
        SELECT app_id FROM Application
        WHERE price >= 0
          AND EXISTS (
              SELECT 1
              FROM Rating r
              WHERE r.app_id = Application.app_id
                AND r.rating_value < 3
          )
        LIMIT 500000
    );
    GET DIAGNOSTICS v_deleted_count = ROW_COUNT;
    v_end_time := clock_timestamp();
    v_elapsed_time := v_end_time - v_start_time;
    RAISE NOTICE 'Deleted % rows in %', v_deleted_count, v_elapsed_time;
    ROLLBACK;


    v_start_time := clock_timestamp();
    DELETE FROM Application
    WHERE price >= 0
      AND EXISTS (
          SELECT 1
          FROM Rating r
          WHERE r.app_id = Application.app_id
            AND r.rating_value < 3
      )
    AND app_id IN (
        SELECT app_id FROM Application
        WHERE price >= 0
          AND EXISTS (
              SELECT 1
              FROM Rating r
              WHERE r.app_id = Application.app_id
                AND r.rating_value < 3
          )
        LIMIT 1000000
    );
    GET DIAGNOSTICS v_deleted_count = ROW_COUNT;
    v_end_time := clock_timestamp();
    v_elapsed_time := v_end_time - v_start_time;
    RAISE NOTICE 'Deleted % rows in %', v_deleted_count, v_elapsed_time;
    ROLLBACK;
END;
$$;
