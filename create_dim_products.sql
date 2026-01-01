CREATE TABLE dim_products (
    product_key SERIAL PRIMARY KEY,
    product_id CHAR(32),
    product_category_name VARCHAR(100),
    product_photos_qty INT,
    product_weight_g INT,
    product_length_cm INT,
    product_height_cm INT,
    product_width_cm INT
);


INSERT INTO dim_products (
    product_id, 
    product_category_name, 
    product_photos_qty, 
    product_weight_g, 
    product_length_cm, 
    product_height_cm, 
    product_width_cm
) SELECT 
    sp.product_id, 
    COALESCE(scnt.product_category_name_english, 'others') AS product_category_name_english, 
    COALESCE(sp.product_photos_qty, 0 ) AS product_photos_qty, 
    sp.product_weight_g,
    sp.product_length_cm, 
    sp.product_height_cm,
    sp.product_width_cm
FROM staging_products sp 
LEFT JOIN staging_category_name_translation scnt 
    ON scnt.product_category_name = sp.product_category_name
where sp.product_weight_g is not null and sp.product_height_cm is not null and sp.product_length_cm is not null and sp.product_width_cm is not NULl;
