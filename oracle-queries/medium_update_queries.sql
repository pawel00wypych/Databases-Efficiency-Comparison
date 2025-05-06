SET TERMOUT ON;
SET FEEDBACK OFF;
SET PAGESIZE 0;
SET LINESIZE 200;
SET TIMING ON;
SET SERVEROUTPUT ON;


BEGIN
    UPDATE Application a
    SET a.price = ROUND(NVL(a.price, 0) * 1.5, 2)
    WHERE a.ROWID IN (
        SELECT a.ROWID
        FROM Application a
        JOIN Rating r ON a.app_id = r.app_id
        JOIN Install_History ih ON a.app_id = ih.app_id
        WHERE r.rating_value >= 3.0 AND ih.installs >= 1000
        AND ROWNUM <= 10000
    );

    DBMS_OUTPUT.PUT_LINE('Rows updated: ' || SQL%ROWCOUNT);
    ROLLBACK;
END;
/

BEGIN
    UPDATE Application a
    SET a.price = ROUND(NVL(a.price, 0) * 1.5, 2)
    WHERE a.ROWID IN (
        SELECT a.ROWID
        FROM Application a
        JOIN Rating r ON a.app_id = r.app_id
        JOIN Install_History ih ON a.app_id = ih.app_id
        WHERE r.rating_value >= 3.0 AND ih.installs >= 1000
        AND ROWNUM <= 100000
    );

    DBMS_OUTPUT.PUT_LINE('Rows updated: ' || SQL%ROWCOUNT);
    ROLLBACK;
END;
/

BEGIN
    UPDATE Application a
    SET a.price = ROUND(NVL(a.price, 0) * 1.5, 2)
    WHERE a.ROWID IN (
        SELECT a.ROWID
        FROM Application a
        JOIN Rating r ON a.app_id = r.app_id
        JOIN Install_History ih ON a.app_id = ih.app_id
        WHERE r.rating_value >= 3.0 AND ih.installs >= 1000
        AND ROWNUM <= 500000
    );

    DBMS_OUTPUT.PUT_LINE('Rows updated: ' || SQL%ROWCOUNT);
    ROLLBACK;
END;
/




BEGIN
    UPDATE Application a
    SET a.price = ROUND(NVL(a.price, 0) * 1.5, 2)
    WHERE a.ROWID IN (
        SELECT a.ROWID
        FROM Application a
        JOIN Rating r ON a.app_id = r.app_id
        JOIN Install_History ih ON a.app_id = ih.app_id
        WHERE r.rating_value >= 3.0 AND ih.installs >= 1000
        AND ROWNUM <= 1000000
    );

    DBMS_OUTPUT.PUT_LINE('Rows updated: ' || SQL%ROWCOUNT);
    ROLLBACK;
END;
/
