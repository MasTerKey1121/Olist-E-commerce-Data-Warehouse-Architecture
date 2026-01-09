-- 00. ล้างข้อมูลเก่าและรีเซ็ตลำดับเลข SERIAL ใหม่ทั้งหมด
TRUNCATE TABLE dim_customers, dim_sellers, dim_products, dim_dates, dim_payments, dim_orders, dim_reviews RESTART IDENTITY CASCADE;

-- 01. dim_customers
INSERT INTO dim_customers (customer_unique_id, customer_zip_code_prefix, customer_city, customer_state)
SELECT 
    customer_unique_id, 
    customer_zip_code_prefix, 
    customer_city, 
    customer_state
FROM (
    SELECT 
        customer_unique_id,
        customer_zip_code_prefix,
        customer_city,
        customer_state,
        ROW_NUMBER() OVER (
            PARTITION BY customer_unique_id 
            ORDER BY customer_id DESC 
        ) as rn
    FROM staging_customers
) t
WHERE t.rn = 1; 

-- 02. dim_sellers
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

-- 03. dim_products
INSERT INTO dim_products (
    product_id, product_category_name, product_photos_qty, 
    product_weight_g, product_length_cm, product_height_cm, product_width_cm
) 
SELECT 
    sp.product_id, 
    COALESCE(scnt.product_category_name_english, 'others') AS category, 
    COALESCE(sp.product_photos_qty, 0), 
    COALESCE(sp.product_weight_g, 0),
    COALESCE(sp.product_length_cm, 0), 
    COALESCE(sp.product_height_cm, 0),
    COALESCE(sp.product_width_cm, 0)
FROM staging_products sp 
LEFT JOIN staging_category_name_translation scnt 
    ON scnt.product_category_name = sp.product_category_name;

-- 04. dim_dates (รัน generate_series ก่อน แล้วค่อยใส่ค่า default 0)
INSERT INTO dim_dates (date_key, full_date, day, month, month_name, quarter, year, day_of_week, day_name, is_weekend)
SELECT 
    TO_CHAR(datum, 'YYYYMMDD')::INT AS date_key,
    datum AS full_date,
    EXTRACT(DAY FROM datum) AS day,
    EXTRACT(MONTH FROM datum) AS month,
    TO_CHAR(datum, 'Month') AS month_name,
    EXTRACT(QUARTER FROM datum) AS quarter,
    EXTRACT(YEAR FROM datum) AS year,
    EXTRACT(ISODOW FROM datum) AS day_of_week,
    TO_CHAR(datum, 'Day') AS day_name,
    CASE WHEN EXTRACT(ISODOW FROM datum) IN (6, 7) THEN TRUE ELSE FALSE END AS is_weekend
FROM generate_series(
    '2016-01-01'::DATE, 
    '2019-12-31'::DATE, 
    '1 day'::INTERVAL
) AS datum;

-- ใส่แถวพิเศษสำหรับข้อมูลที่ไม่มีวันที่ (Unknown Date)
INSERT INTO dim_dates (date_key, full_date, day, month, month_name, quarter, year, day_of_week, day_name, is_weekend)
VALUES (0, '1900-01-01', 1, 1, 'January', 1, 1900, 1, 'Monday', FALSE)
ON CONFLICT (date_key) DO NOTHING;

-- 05. dim_payments
INSERT INTO dim_payments (payment_type_name)
SELECT payment_type 
FROM staging_order_payments
GROUP BY payment_type
ORDER BY count(*) DESC;

-- 06. dim_orders (เชื่อมข้อมูลกับ dim_customers เพื่อเอา customer_key)
INSERT INTO dim_orders (order_id, customer_key, order_status, 
    order_purchase_date_key, order_approved_date_key,
    order_shipped_date_key, order_delivered_date_key,
    order_estimated_delivery_date_key, purchase_hour)
SELECT 
    soc.order_id, 
    dsc.customer_key, 
    soc.order_status, 
    soc.order_purchase_date_key,
    soc.order_approved_date_key,
    soc.order_shipped_date_key,
    soc.order_delivered_date_key,
    soc.order_estimated_delivery_date_key,
    soc.purchase_hour
FROM (
    SELECT so.order_id, so.customer_id, so.order_status,
    COALESCE(TO_CHAR(so.order_purchase_timestamp, 'YYYYMMDD')::INT, 0) as order_purchase_date_key,
    COALESCE(TO_CHAR(so.order_approved_at, 'YYYYMMDD')::INT, 0) as order_approved_date_key,
    COALESCE(TO_CHAR(so.order_delivered_carrier_date, 'YYYYMMDD')::INT, 0) as order_shipped_date_key,
    COALESCE(TO_CHAR(so.order_delivered_customer_date, 'YYYYMMDD')::INT, 0) as order_delivered_date_key,
    COALESCE(TO_CHAR(so.order_estimated_delivery_date, 'YYYYMMDD')::INT, 0) as order_estimated_delivery_date_key,
    COALESCE(EXTRACT(HOUR FROM so.order_purchase_timestamp)::INT, -1) as purchase_hour
    FROM staging_orders so
) AS soc
JOIN staging_customers sc ON sc.customer_id = soc.customer_id
JOIN dim_customers dsc ON dsc.customer_unique_id = sc.customer_unique_id;

-- 07. dim_reviews 
INSERT INTO dim_reviews (
    review_id, 
    review_score, 
    review_response_time_days,
    review_response_speed_category
)
SELECT 
    review_id,
    review_score,
    DATE_PART('day', review_answer_timestamp - review_creation_date) AS response_time_days,
    CASE 
        WHEN review_answer_timestamp IS NULL THEN 'No Response'
        WHEN DATE_PART('day', review_answer_timestamp - review_creation_date) <= 1 THEN 'Fast'
        WHEN DATE_PART('day', review_answer_timestamp - review_creation_date) <= 3 THEN 'Normal'
        ELSE 'Slow'
    END AS response_speed_category
FROM staging_order_reviews;