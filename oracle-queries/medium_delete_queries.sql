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
    WHERE price >= 0
    AND EXISTS (
      SELECT 1
      FROM Rating r
      WHERE r.app_id = Application.app_id
        AND r.rating_value < 3
    )
    AND ROWNUM <= 10000;

    DBMS_OUTPUT.PUT_LINE('Rows deleted: ' || SQL%ROWCOUNT);

    ROLLBACK;
END;
/

BEGIN
    DELETE FROM Application
    WHERE price >= 0
    AND EXISTS (
      SELECT 1
      FROM Rating r
      WHERE r.app_id = Application.app_id
        AND r.rating_value < 3
    )
    AND ROWNUM <= 100000;

    DBMS_OUTPUT.PUT_LINE('Rows deleted: ' || SQL%ROWCOUNT);

    ROLLBACK;
END;
/

BEGIN
    DELETE FROM Application
    WHERE price >= 0
    AND EXISTS (
      SELECT 1
      FROM Rating r
      WHERE r.app_id = Application.app_id
        AND r.rating_value < 3
    )
    AND ROWNUM <= 500000;

    DBMS_OUTPUT.PUT_LINE('Rows deleted: ' || SQL%ROWCOUNT);

    ROLLBACK;
END;
/

BEGIN
    DELETE FROM Application
    WHERE price >= 0
    AND EXISTS (
      SELECT 1
      FROM Rating r
      WHERE r.app_id = Application.app_id
        AND r.rating_value < 3
    )
    AND ROWNUM <= 1000000;

    DBMS_OUTPUT.PUT_LINE('Rows deleted: ' || SQL%ROWCOUNT);

    ROLLBACK;
END;
/