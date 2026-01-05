create table fact_order_items(
    order_item_key SERIAL PRIMARY KEY,
    order_key INT NOT NULL,
    product_key INT NOT NULL,
    seller_key INT NOT NULL,
    shipping_limit_date TIMESTAMP NOT NULL,
    price NUMERIC(10,2) NOT NULL,
    freight_value NUMERIC(10,2) NOT NULL
);

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