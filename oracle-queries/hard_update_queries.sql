SET TERMOUT ON;
SET FEEDBACK OFF;
SET PAGESIZE 0;
SET LINESIZE 200;
SET TIMING ON;
SET SERVEROUTPUT ON;

BEGIN
    MERGE INTO Application a
    USING (
        SELECT a2.app_id, r.rating_value, d.developer_email, d.developer_name
        FROM Application a2
        JOIN Rating r ON a2.app_id = r.app_id
        JOIN Install_History ih ON a2.app_id = ih.app_id
        JOIN Developer d ON a2.developer_id = d.developer_id
        WHERE ih.installs >= 1
          AND (r.rating_value >= 3.0 OR REGEXP_LIKE(d.developer_name, '.*hack.*', 'i'))
          AND ROWNUM <= 10000
    ) src
    ON (a.app_id = src.app_id)
    WHEN MATCHED THEN
        UPDATE SET
            a.price = ROUND(
                CASE
                    WHEN src.rating_value >= 4.5 THEN NVL(a.price, 0) * 1.15
                    WHEN src.rating_value >= 3.0 THEN NVL(a.price, 0) * 1.05
                    ELSE NVL(a.price, 0) * 0.95
                END, 2),
            a.privacy_policy = LOWER(SUBSTR(a.privacy_policy, 1, 100)),
            a.app_size = CASE
                WHEN a.app_size IS NULL THEN ROUND(DBMS_RANDOM.VALUE(10, 100), 2)
                ELSE a.app_size
            END;

    DBMS_OUTPUT.PUT_LINE('Rows updated: ' || SQL%ROWCOUNT);

    ROLLBACK;
END;
/

BEGIN
    MERGE INTO Application a
    USING (
        SELECT a2.app_id, r.rating_value, d.developer_email, d.developer_name
        FROM Application a2
        JOIN Rating r ON a2.app_id = r.app_id
        JOIN Install_History ih ON a2.app_id = ih.app_id
        JOIN Developer d ON a2.developer_id = d.developer_id
        WHERE ih.installs >= 1
          AND (r.rating_value >= 3.0 OR REGEXP_LIKE(d.developer_name, '.*hack.*', 'i'))
          AND ROWNUM <= 100000
    ) src
    ON (a.app_id = src.app_id)
    WHEN MATCHED THEN
        UPDATE SET
            a.price = ROUND(
                CASE
                    WHEN src.rating_value >= 4.5 THEN NVL(a.price, 0) * 1.15
                    WHEN src.rating_value >= 3.0 THEN NVL(a.price, 0) * 1.05
                    ELSE NVL(a.price, 0) * 0.95
                END, 2),
            a.privacy_policy = LOWER(SUBSTR(a.privacy_policy, 1, 100)),
            a.app_size = CASE
                WHEN a.app_size IS NULL THEN ROUND(DBMS_RANDOM.VALUE(10, 100), 2)
                ELSE a.app_size
            END;


    DBMS_OUTPUT.PUT_LINE('Rows updated: ' || SQL%ROWCOUNT);

    ROLLBACK;
END;
/

BEGIN
    MERGE INTO Application a
    USING (
        SELECT a2.app_id, r.rating_value, d.developer_email, d.developer_name
        FROM Application a2
        JOIN Rating r ON a2.app_id = r.app_id
        JOIN Install_History ih ON a2.app_id = ih.app_id
        JOIN Developer d ON a2.developer_id = d.developer_id
        WHERE ih.installs >= 1
          AND (r.rating_value >= 3.0 OR REGEXP_LIKE(d.developer_name, '.*hack.*', 'i'))
          AND ROWNUM <= 500000
    ) src
    ON (a.app_id = src.app_id)
    WHEN MATCHED THEN
        UPDATE SET
            a.price = ROUND(
                CASE
                    WHEN src.rating_value >= 4.5 THEN NVL(a.price, 0) * 1.15
                    WHEN src.rating_value >= 3.0 THEN NVL(a.price, 0) * 1.05
                    ELSE NVL(a.price, 0) * 0.95
                END, 2),
            a.privacy_policy = LOWER(SUBSTR(a.privacy_policy, 1, 100)),
            a.app_size = CASE
                WHEN a.app_size IS NULL THEN ROUND(DBMS_RANDOM.VALUE(10, 100), 2)
                ELSE a.app_size
            END;

    DBMS_OUTPUT.PUT_LINE('Rows updated: ' || SQL%ROWCOUNT);

    ROLLBACK;
END;
/

BEGIN
    MERGE INTO Application a
    USING (
        SELECT a2.app_id, r.rating_value, d.developer_email, d.developer_name
        FROM Application a2
        JOIN Rating r ON a2.app_id = r.app_id
        JOIN Install_History ih ON a2.app_id = ih.app_id
        JOIN Developer d ON a2.developer_id = d.developer_id
        WHERE ih.installs >= 1
          AND (r.rating_value >= 3.0 OR REGEXP_LIKE(d.developer_name, '.*hack.*', 'i'))
          AND ROWNUM <= 1000000
    ) src
    ON (a.app_id = src.app_id)
    WHEN MATCHED THEN
        UPDATE SET
            a.price = ROUND(
                CASE
                    WHEN src.rating_value >= 4.5 THEN NVL(a.price, 0) * 1.15
                    WHEN src.rating_value >= 3.0 THEN NVL(a.price, 0) * 1.05
                    ELSE NVL(a.price, 0) * 0.95
                END, 2),
            a.privacy_policy = LOWER(SUBSTR(a.privacy_policy, 1, 100)),
            a.app_size = CASE
                WHEN a.app_size IS NULL THEN ROUND(DBMS_RANDOM.VALUE(10, 100), 2)
                ELSE a.app_size
            END;

    DBMS_OUTPUT.PUT_LINE('Rows updated: ' || SQL%ROWCOUNT);

    ROLLBACK;
END;
/
