-- 00. ล้างข้อมูลเก่าใน Fact Tables ทั้งหมดก่อนเริ่มโหลดใหม่
-- เราใช้ CASCADE เพราะตารางเหล่านี้อาจมีความสัมพันธ์กัน
TRUNCATE TABLE fact_order_items, fact_order_payments, fact_order_reviews RESTART IDENTITY CASCADE;

-- 01. fact_order_items
INSERT INTO fact_order_items (order_key, product_key, seller_key, shipping_limit_date, price, freight_value)
SELECT 
    dmo.order_key, 
    dp.product_key,
    ds.seller_key,
    soi.shipping_limit_date, 
    soi.price, 
    soi.freight_value 
FROM staging_order_items soi
JOIN dim_orders dmo ON dmo.order_id = soi.order_id
JOIN dim_products dp ON dp.product_id = soi.product_id
JOIN dim_sellers ds ON ds.seller_id = soi.seller_id;

-- 02. fact_order_payments
INSERT INTO fact_order_payments (order_key, customer_key, payment_type_key, payment_date_key, payment_sequential, payment_installments, payment_value)
SELECT 
    t.order_key, 
    t.customer_key, 
    dp.payment_type_key, 
    t.order_purchase_date_key AS payment_date_key, -- ใช้จาก dim_orders ตาม logic เดิมของคุณ
    sop.payment_sequential,
    sop.payment_installments,
    sop.payment_value 
FROM staging_order_payments sop 
JOIN dim_orders t ON t.order_id = sop.order_id 
JOIN dim_payments dp ON dp.payment_type_name = sop.payment_type;

-- 03. fact_order_reviews
INSERT INTO fact_order_reviews (order_key, review_key)
SELECT 
    dro.order_key,
    dr.review_key
FROM staging_order_reviews sor
JOIN dim_orders dro ON sor.order_id = dro.order_id
JOIN dim_reviews dr ON sor.review_id = dr.review_id;

-- End of ETL for fact tables