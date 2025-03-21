#!/bin/bash

ORACLE_USER="ztbd"
ORACLE_PASSWORD="password"
ORACLE_SID="FREE"
DATA_FILE="/shared-data/Google-Playstore.csv"

echo "Starting data load into Oracle Database..."

tail -n +2 "$DATA_FILE" | while IFS=',' read -r app_name app_id category rating rating_count installs min_installs max_installs free price currency size min_android developer_name developer_website developer_email released last_updated content_rating privacy_policy ad_supported in_app_purchases editor_choice scraped_time
do
    # removing " and ' from data
    app_name=$(echo "$app_name" | sed "s/'/''/g")
    developer_name=$(echo "$developer_name" | sed "s/'/''/g")
    developer_website=$(echo "$developer_website" | sed "s/'/''/g")
    developer_email=$(echo "$developer_email" | sed "s/'/''/g")
    currency=$(echo "$currency" | sed "s/'/''/g")
    category=$(echo "$category" | sed "s/'/''/g")
    content_rating=$(echo "$content_rating" | sed "s/'/''/g")
    privacy_policy=$(echo "$privacy_policy" | sed "s/'/''/g")

    sqlplus -s ${ORACLE_USER}/${ORACLE_PASSWORD}@${ORACLE_SID} <<EOF
        SET SERVEROUTPUT ON;
        SET DEFINE OFF;
        DECLARE
            -- Declare all the necessary variables
            currency_id NUMBER;
            developer_id NUMBER;
            content_rating_id NUMBER;
            app_id NUMBER;
            category_id NUMBER;

            start_time NUMBER;
            end_time NUMBER;
            elapsed_time NUMBER;

            start_op NUMBER;
            end_op NUMBER;
            elapsed_op NUMBER;
        BEGIN
            -- Start time measure for all queries
            start_time := DBMS_UTILITY.GET_TIME;

            start_op := DBMS_UTILITY.GET_TIME;

            -- Handle Currency insertion
            MERGE INTO Currency c
            USING (SELECT '$currency' AS currency_name FROM dual) src
            ON (c.currency_name = src.currency_name)
            WHEN NOT MATCHED THEN
                INSERT (currency_name) VALUES (src.currency_name);

            SELECT currency_id INTO currency_id FROM Currency WHERE currency_name = '$currency';

            end_op := DBMS_UTILITY.GET_TIME;
            elapsed_op := (end_op - start_op) / 100;
            DBMS_OUTPUT.PUT_LINE('Time for Currency: ' || elapsed_op || ' seconds');

            start_op := DBMS_UTILITY.GET_TIME;

            -- Handle Developer insertion
            MERGE INTO Developer d
            USING (SELECT '$developer_name' AS developer_name, '$developer_website' AS developer_website, '$developer_email' AS developer_email FROM dual) src
            ON (d.developer_name = src.developer_name)
            WHEN NOT MATCHED THEN
                INSERT (developer_name, developer_website, developer_email)
                VALUES (src.developer_name, src.developer_website, src.developer_email);

            SELECT developer_id INTO developer_id FROM Developer WHERE developer_name = '$developer_name';

            end_op := DBMS_UTILITY.GET_TIME;
            elapsed_op := (end_op - start_op) / 100;
            DBMS_OUTPUT.PUT_LINE('Time for Developer: ' || elapsed_op || ' seconds');

            start_op := DBMS_UTILITY.GET_TIME;

            -- Handle Content Rating insertion
            MERGE INTO Content_Rating cr
            USING (SELECT '$content_rating' AS rating_name FROM dual) src
            ON (cr.rating_name = src.rating_name)
            WHEN NOT MATCHED THEN
                INSERT (rating_name) VALUES (src.rating_name);

            SELECT content_rating_id INTO content_rating_id FROM Content_Rating WHERE rating_name = '$content_rating';

            end_op := DBMS_UTILITY.GET_TIME;
            elapsed_op := (end_op - start_op) / 100;
            DBMS_OUTPUT.PUT_LINE('Time for Content Rating: ' || elapsed_op || ' seconds');

            -- Insert into Application table
            INSERT INTO Application (
                app_name, free, price, currency_id, "size", developer_id, released, privacy_policy, last_updated, content_rating_id, ad_supported, in_app_purchases, editor_choice
            ) VALUES (
                '$app_name', '$free', '$price', currency_id, '$size', developer_id,
                TO_DATE('$released', 'DD-MON-YYYY'), '$privacy_policy',
                TO_DATE('$last_updated', 'DD-MON-YYYY'), content_rating_id,
                '$ad_supported', '$in_app_purchases', '$editor_choice'
            );

            -- Capture the app_id
            SELECT app_id INTO app_id FROM Application WHERE app_name = '$app_name';

            -- Handle Category insertion
            MERGE INTO Category c
            USING (SELECT '$category' AS category_name FROM dual) src
            ON (c.category_name = src.category_name)
            WHEN NOT MATCHED THEN
                INSERT (category_name) VALUES (src.category_name);

            SELECT category_id INTO category_id FROM Category WHERE category_name = '$category';

            -- Associate application with category
            INSERT INTO Application_Category (app_id, category_id)
            VALUES (app_id, category_id);

            -- Handle Install History
            INSERT INTO Install_History (app_id, date_recorded, installs)
            VALUES (app_id, TO_DATE('$scraped_time', 'DD-MON-YYYY'), '$installs');

            -- Handle Rating insertion
            INSERT INTO Rating (app_id, rating_value, rating_date)
            VALUES (app_id, '$rating', TO_DATE('$scraped_time', 'DD-MON-YYYY'));

            end_op := DBMS_UTILITY.GET_TIME;
            elapsed_op := (end_op - start_op) / 100;
            DBMS_OUTPUT.PUT_LINE('Time for Operation: ' || elapsed_op || ' seconds');

            end_time := DBMS_UTILITY.GET_TIME;
            elapsed_time := (end_time - start_time) / 100;
            DBMS_OUTPUT.PUT_LINE('Total Execution Time: ' || elapsed_time || ' seconds');

        END;
    /
    COMMIT;
EOF
done

echo "Data load completed."
