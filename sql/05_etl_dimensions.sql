-- 01. fact_orders_items
INSERT INTO fact_order_items (order_key, product_key, seller_key, shipping_limit_date, price, freight_value)
select 
dmo.order_key, 
dp.product_key ,
 ds.seller_key,
 soi.shipping_limit_date , soi.price , soi.freight_value 
from staging_order_items soi
join dim_orders dmo on dmo.order_id  = soi.order_id
join dim_products dp on dp.product_id  = soi.product_id
join dim_sellers ds on ds.seller_id  = soi.seller_id;


-- 02. fact_order_payments
INSERT INTO fact_order_payments (order_key, customer_key, payment_type_key, payment_date_key, payment_sequential, payment_installments, payment_value)
select t.order_key, t.customer_key , dp.payment_type_key , t.order_purchase_date_key as payment_date_key ,sop.payment_sequential ,sop.payment_installments ,sop.payment_value 
from staging_order_payments sop 
join dim_orders t on t.order_id = sop.order_id 
join dim_payments dp on dp.payment_type_name  = sop.payment_type ;

-- 03. fact_order_reviews
INSERT INTO fact_order_reviews (order_key, review_key)
SELECT 
    dro.order_key,
    dr.review_key
FROM staging_order_reviews sor
JOIN dim_orders dro ON sor.order_id = dro.order_id
JOIN dim_reviews dr ON sor.review_id = dr.review_id;