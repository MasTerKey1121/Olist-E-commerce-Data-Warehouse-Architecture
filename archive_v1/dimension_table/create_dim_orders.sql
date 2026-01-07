CREATE TABLE dim_orders (
    order_key SERIAL PRIMARY KEY,
    order_id CHAR(32) NOT NULL,
    customer_key INT NOT NULL,
    order_status VARCHAR(20) NOT NULL,
    order_purchase_date_key INT NOT NULL,
    order_approved_date_key INT,
    order_shipped_date_key INT,
    order_delivered_date_key INT,
    order_estimated_delivery_date_key INT,
    purchase_hour INT
);
INSERT INTO dim_orders (order_id, customer_key, order_status, 
order_purchase_date_key, order_approved_date_key,
order_shipped_date_key, order_delivered_date_key,
order_estimated_delivery_date_key, purchase_hour)
select 
    order_id, 
    dsc.customer_key, 
    order_status, 
    order_purchase_date_key,
    order_approved_date_key,
    order_shipped_date_key,
    order_delivered_date_key,
    order_estimated_delivery_date_key,
    purchase_hour
from(
	select so.order_id, sc.customer_unique_id , so.order_status 
	,COALESCE(TO_CHAR(so.order_purchase_timestamp, 'YYYYMMDD')::INT, 0) as order_purchase_date_key
	,COALESCE(TO_CHAR(so.order_approved_at, 'YYYYMMDD')::INT, 0) as order_approved_date_key
	,coalesce(TO_CHAR(so.order_delivered_carrier_date, 'YYYYMMDD'):: INT, 0) as  order_shipped_date_key
	,coalesce(TO_CHAR(so.order_delivered_customer_date, 'YYYYMMDD'):: INT, 0) as order_delivered_date_key
	,coalesce(TO_CHAR(so.order_estimated_delivery_date, 'YYYYMMDD'):: INT, 0) as order_estimated_delivery_date_key
	,coalesce(extract(hour from so.order_purchase_timestamp)::INT ,-1) as purchase_hour
	from staging_orders so
	join staging_customers sc on sc.customer_id  = so.customer_id 
) as soc
join dim_customers dsc on dsc.customer_unique_id  = soc.customer_unique_id;
order by dsc.customer_key ASC;


