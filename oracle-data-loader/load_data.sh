#!/bin/bash

ORACLE_USER="ztbd"
ORACLE_PASSWORD="password"
ORACLE_SID="FREE"
DATA_FILE="/shared-data/Google-Playstore.csv"

echo "Starting data load into Oracle Database..."

tail -n +2 "$DATA_FILE" | while IFS=',' read -r app_name app_id category rating rating_count installs min_installs max_installs free price currency size min_android developer_name developer_website developer_email released last_updated content_rating privacy_policy ad_supported in_app_purchases editor_choice scraped_time
do
    # Escape single quotes for SQL
    escape_sql() {
        echo "$1" | sed "s/'/''/g"
    }

    app_name=$(escape_sql "$app_name")
    developer_name=$(escape_sql "$developer_name")
    developer_website=$(escape_sql "$developer_website")
    developer_email=$(escape_sql "$developer_email")
    currency=$(escape_sql "$currency")
    category=$(escape_sql "$category")
    content_rating=$(escape_sql "$content_rating")
    privacy_policy=$(escape_sql "$privacy_policy")

    # Convert Boolean values to '1' or '0'
    free=$( [ "$free" = "True" ] && echo "1" || echo "0" )
    ad_supported=$( [ "$ad_supported" = "True" ] && echo "1" || echo "0" )
    in_app_purchases=$( [ "$in_app_purchases" = "True" ] && echo "1" || echo "0" )
    editor_choice=$( [ "$editor_choice" = "True" ] && echo "1" || echo "0" )

    # Convert size and installs
    size=$(echo "$size" | sed -E 's/([0-9.]+)M/\1 * 1000000/' | awk '{print int($1)}')
    installs=$(echo "$installs" | sed -E 's/([0-9.]+)M/\1 * 1000000/' | awk '{print int($1)}')

    # Convert Date Formats (handling different formats)
    convert_date() {
        if [[ -z "$1" || "$1" == "NULL" ]]; then
            echo "NULL"
        elif [[ "$1" =~ ^[0-9]{4}-[0-9]{2}-[0-9]{2}$ ]]; then
            date -d "$1" +"%d-%b-%Y" 2>/dev/null
        elif echo "$1" | grep -Eq "^[A-Za-z]+ [0-9]+, [0-9]{4}$"; then
            date -d "$1" +"%d-%b-%Y" 2>/dev/null
        else
            echo "NULL"
        fi
    }

    released=$(convert_date "$released")
    last_updated=$(convert_date "$last_updated")
    scraped_time=$(convert_date "$scraped_time")

    # Ensure price and size are numeric
    if ! [[ "$price" =~ ^[0-9]+(\.[0-9]+)?$ ]]; then price="0"; fi
    if ! [[ "$size" =~ ^[0-9]+$ ]]; then size="0"; fi
    if ! [[ "$rating" =~ ^[0-9]+(\.[0-9]+)?$ ]]; then rating="NULL"; fi

    echo "DEBUG: free=$free, ad_supported=$ad_supported, in_app_purchases=$in_app_purchases, editor_choice=$editor_choice"

    sqlplus -s ${ORACLE_USER}/${ORACLE_PASSWORD}@${ORACLE_SID} <<EOF
        SET SERVEROUTPUT ON;
        SET DEFINE OFF;
        DECLARE
            currency_id NUMBER;
            developer_id NUMBER;
            content_rating_id NUMBER;
            app_id NUMBER;
            category_id NUMBER;
        BEGIN
            -- Handle Currency insertion
            MERGE INTO Currency c
            USING (SELECT '$currency' AS currency_name FROM dual) src
            ON (c.currency_name = src.currency_name)
            WHEN NOT MATCHED THEN
                INSERT (currency_name) VALUES (src.currency_name);

            SELECT MIN(currency_id) INTO currency_id FROM Currency WHERE currency_name = '$currency';

            -- Handle Developer insertion
            MERGE INTO Developer d
            USING (SELECT '$developer_name' AS developer_name, '$developer_website' AS developer_website, '$developer_email' AS developer_email FROM dual) src
            ON (d.developer_name = src.developer_name)
            WHEN NOT MATCHED THEN
                INSERT (developer_name, developer_website, developer_email)
                VALUES (src.developer_name, src.developer_website, src.developer_email);

            SELECT MIN(developer_id) INTO developer_id FROM Developer WHERE developer_name = '$developer_name';

            -- Handle Content Rating insertion
            MERGE INTO Content_Rating cr
            USING (SELECT '$content_rating' AS rating_name FROM dual) src
            ON (cr.rating_name = src.rating_name)
            WHEN NOT MATCHED THEN
                INSERT (rating_name) VALUES (src.rating_name);

            SELECT MIN(content_rating_id) INTO content_rating_id FROM Content_Rating WHERE rating_name = '$content_rating';

            -- Insert into Application table
            INSERT INTO Application (app_name, free, price, currency_id, "size", developer_id, released, privacy_policy, last_updated, content_rating_id, ad_supported, in_app_purchases, editor_choice)
            VALUES ('$app_name', $free, $price, currency_id, $size, developer_id,
                    NVL(NULLIF('$released', 'NULL'), NULL),
                    '$privacy_policy',
                    NVL(NULLIF('$last_updated', 'NULL'), NULL),
                    content_rating_id, $ad_supported, $in_app_purchases, $editor_choice);

            -- Capture the app_id
            SELECT MIN(app_id) INTO app_id FROM Application WHERE app_name = '$app_name';

            -- Handle Category insertion
            MERGE INTO Category c
            USING (SELECT '$category' AS category_name FROM dual) src
            ON (c.category_name = src.category_name)
            WHEN NOT MATCHED THEN
                INSERT (category_name) VALUES (src.category_name);

            SELECT MIN(category_id) INTO category_id FROM Category WHERE category_name = '$category';

            -- Associate application with category
            INSERT INTO Application_Category (app_id, category_id)
            VALUES (app_id, category_id);

            -- Handle Install History
            INSERT INTO Install_History (app_id, date_recorded, installs)
            VALUES (app_id, NVL(NULLIF('$scraped_time', 'NULL'), NULL), $installs);

            -- Handle Rating insertion
            INSERT INTO Rating (app_id, rating_value, rating_date)
            VALUES (app_id, $rating, NVL(NULLIF('$scraped_time', 'NULL'), NULL));

            DBMS_OUTPUT.PUT_LINE('Data successfully inserted.');
        END;
    /
    COMMIT;
EOF
done

echo "Data load completed."
