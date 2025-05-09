SET TERMOUT ON;
SET FEEDBACK OFF;
SET PAGESIZE 0;
SET LINESIZE 200;
SET TIMING ON;


SELECT * FROM (SELECT a.app_name, d.developer_name, r.rating_value
                               FROM Application a
                                        JOIN Developer d ON a.developer_id = d.developer_id
                                        JOIN Rating r ON a.app_id = r.app_id
                               )
WHERE ROWNUM <= 10000;


SELECT * FROM (SELECT a.app_name, d.developer_name, r.rating_value
                               FROM Application a
                                        JOIN Developer d ON a.developer_id = d.developer_id
                                        JOIN Rating r ON a.app_id = r.app_id
                               )
WHERE ROWNUM <= 100000;


SELECT * FROM (SELECT a.app_name, d.developer_name, r.rating_value
                               FROM Application a
                                JOIN Developer d ON a.developer_id = d.developer_id
                                JOIN Rating r ON a.app_id = r.app_id)
         CROSS JOIN (SELECT LEVEL AS n FROM dual CONNECT BY LEVEL <= 10)
WHERE ROWNUM <= 500000;


SELECT * FROM (SELECT a.app_name, d.developer_name, r.rating_value
                            FROM Application a
                            JOIN Developer d ON a.developer_id = d.developer_id
                            JOIN Rating r ON a.app_id = r.app_id)
         CROSS JOIN (SELECT LEVEL AS n FROM dual CONNECT BY LEVEL <= 10)
WHERE ROWNUM <= 1000000;

EXIT;