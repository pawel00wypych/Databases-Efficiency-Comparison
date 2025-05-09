SET TERMOUT ON;
SET FEEDBACK OFF;
SET PAGESIZE 0;
SET LINESIZE 200;
SET TIMING ON;
SET SERVEROUTPUT ON;


BEGIN
    UPDATE Application
    SET price = 100.0
    WHERE ROWID IN (
        SELECT ROWID FROM Application WHERE ROWNUM <= 10000
    );

    DBMS_OUTPUT.PUT_LINE('Rows updated: ' || SQL%ROWCOUNT);

    ROLLBACK;
END;
/

BEGIN
    UPDATE Application
    SET price = 100.0
    WHERE ROWID IN (
        SELECT ROWID FROM Application WHERE ROWNUM <= 100000
    );

    DBMS_OUTPUT.PUT_LINE('Rows updated: ' || SQL%ROWCOUNT);

    ROLLBACK;
END;
/

BEGIN
    UPDATE Application
    SET price = 100.0
    WHERE ROWID IN (
        SELECT ROWID FROM Application WHERE ROWNUM <= 500000
    );

    DBMS_OUTPUT.PUT_LINE('Rows updated: ' || SQL%ROWCOUNT);

    ROLLBACK;
END;
/




BEGIN
    UPDATE Application
    SET price = 100.0
    WHERE ROWID IN (
        SELECT ROWID FROM Application WHERE ROWNUM <= 1000000
    );

    DBMS_OUTPUT.PUT_LINE('Rows updated: ' || SQL%ROWCOUNT);

    ROLLBACK;
END;
/
