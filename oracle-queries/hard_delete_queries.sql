SET TERMOUT ON;
SET FEEDBACK OFF;
SET PAGESIZE 0;
SET LINESIZE 200;
SET TIMING ON;
SET SERVEROUTPUT ON;

CREATE INDEX idx_rating_app_id ON Rating(app_id);
CREATE INDEX idx_install_history_app_id ON Install_History(app_id);
CREATE INDEX idx_app_cat_app_id ON Application_Category(app_id);

BEGIN
    DELETE FROM Application
    WHERE app_id IN (
        SELECT a.app_id
        FROM Application a
        JOIN Rating r ON a.app_id = r.app_id
        JOIN Install_History ih ON a.app_id = ih.app_id
        WHERE r.rating_value < 4
          AND ih.maximum_installs < 10000
    )
    AND ROWNUM <= 10000;

    DBMS_OUTPUT.PUT_LINE('Rows deleted: ' || SQL%ROWCOUNT);

    ROLLBACK;
END;
/

BEGIN
    DELETE FROM Application
    WHERE app_id IN (
        SELECT a.app_id
        FROM Application a
        JOIN Rating r ON a.app_id = r.app_id
        JOIN Install_History ih ON a.app_id = ih.app_id
        WHERE r.rating_value < 4
          AND ih.maximum_installs < 10000
    )
    AND ROWNUM <= 100000;

    DBMS_OUTPUT.PUT_LINE('Rows deleted: ' || SQL%ROWCOUNT);

    ROLLBACK;
END;
/

BEGIN
    DELETE FROM Application
    WHERE app_id IN (
        SELECT a.app_id
        FROM Application a
        JOIN Rating r ON a.app_id = r.app_id
        JOIN Install_History ih ON a.app_id = ih.app_id
        WHERE r.rating_value < 4
          AND ih.maximum_installs < 10000
    )
    AND ROWNUM <= 500000;

    DBMS_OUTPUT.PUT_LINE('Rows deleted: ' || SQL%ROWCOUNT);

    ROLLBACK;
END;
/

BEGIN
    DELETE FROM Application
    WHERE app_id IN (
        SELECT a.app_id
        FROM Application a
        JOIN Rating r ON a.app_id = r.app_id
        JOIN Install_History ih ON a.app_id = ih.app_id
        WHERE r.rating_value < 4
          AND ih.maximum_installs < 10000
    )
    AND ROWNUM <= 1000000;

    DBMS_OUTPUT.PUT_LINE('Rows deleted: ' || SQL%ROWCOUNT);

    ROLLBACK;
END;
/