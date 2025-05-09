SET TERMOUT ON;
SET FEEDBACK OFF;
SET PAGESIZE 0;
SET LINESIZE 200;
SET TIMING ON;


SELECT d.developer_name, COUNT(a.app_id) AS app_count, SUM(i.installs) AS total_installs
FROM Application a
JOIN Developer d ON a.developer_id = d.developer_id
JOIN Install_History i ON a.app_id = i.app_id
CROSS JOIN (SELECT LEVEL AS n FROM dual CONNECT BY LEVEL <= 100)
GROUP BY d.developer_name
HAVING COUNT(a.app_id) > 1
FETCH FIRST 10000 ROWS ONLY;


SELECT a.app_name, a.app_address, a.ad_supported ,d.developer_name, COUNT(a.app_id) AS app_count, SUM(i.installs) AS total_installs
FROM Application a
JOIN Developer d ON a.developer_id = d.developer_id
JOIN Install_History i ON a.app_id = i.app_id
CROSS JOIN (SELECT LEVEL AS n FROM dual CONNECT BY LEVEL <= 100)
GROUP BY d.developer_name, a.app_name, a.app_address, a.ad_supported
HAVING COUNT(a.app_id) > 1
FETCH FIRST 100000 ROWS ONLY;


SELECT a.app_name, a.app_address, a.ad_supported, d.developer_name, COUNT(a.app_id) AS app_count, SUM(i.installs) AS total_installs
FROM Application a
JOIN Developer d ON a.developer_id = d.developer_id
JOIN Install_History i ON a.app_id = i.app_id
CROSS JOIN (SELECT LEVEL AS n FROM dual CONNECT BY LEVEL <= 100)
GROUP BY d.developer_name, a.app_name, a.app_address, a.ad_supported
HAVING COUNT(a.app_id) > 1
FETCH FIRST 500000 ROWS ONLY;


SELECT a.app_name, a.app_address, a.ad_supported, d.developer_name, COUNT(a.app_id) AS app_count, SUM(i.installs) AS total_installs
FROM Application a
JOIN Developer d ON a.developer_id = d.developer_id
JOIN Install_History i ON a.app_id = i.app_id
CROSS JOIN (SELECT LEVEL AS n FROM dual CONNECT BY LEVEL <= 100)
GROUP BY d.developer_name, a.app_name, a.app_address, a.ad_supported
HAVING COUNT(a.app_id) > 1
FETCH FIRST 1000000 ROWS ONLY;

EXIT;