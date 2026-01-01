CREATE TABLE dim_sellers (
    seller_key SERIAL PRIMARY KEY,
    seller_id CHAR(32),
    seller_zip_code_prefix CHAR(5),
    seller_city VARCHAR(50),
    seller_state CHAR(2)
);

INSERT INTO dim_sellers (seller_id, seller_zip_code_prefix, seller_city, seller_state)
SELECT 
    seller_id, 
    seller_zip_code_prefix, 
    seller_city, 
    seller_state
FROM (
    SELECT
        seller_id,
        seller_zip_code_prefix,
        seller_city,
        seller_state,
        ROW_NUMBER() OVER (
            PARTITION BY seller_id 
            ORDER BY seller_id DESC 
        ) as rn
    FROM staging_sellers
) t
WHERE t.rn = 1;