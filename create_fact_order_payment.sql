create table fact_order_payments(
    order_payment_key SERIAL PRIMARY KEY,
    order_key INT NOT NULL,
    customer_key INT NOT NULL,
    payment_type_key INT NOT NULL,
    payment_date_key INT NOT NULL,
    payment_sequential INT,
    payment_installments INT,
    payment_value NUMERIC(10,2),

    CONSTRAINT fk_fact_payments_orders FOREIGN KEY (order_key) REFERENCES dim_orders (order_key),
    CONSTRAINT fk_fact_payments_customers FOREIGN KEY (customer_key) REFERENCES dim_customers (customer_key),
    CONSTRAINT fk_fact_payments_types FOREIGN KEY (payment_type_key) REFERENCES dim_payments (payment_type_key),
    CONSTRAINT fk_fact_payments_dates FOREIGN KEY (payment_date_key) REFERENCES dim_dates (date_key)
);


INSERT INTO fact_order_payments (order_key, customer_key, payment_type_key, payment_date_key, payment_sequential, payment_installments, payment_value)
select t.order_key, t.customer_key , dp.payment_type_key , t.order_purchase_date_key as payment_date_key ,sop.payment_sequential ,sop.payment_installments ,sop.payment_value 
from staging_order_payments sop 
join dim_orders t on t.order_id = sop.order_id 
join dim_payments dp on dp.payment_type_name  = sop.payment_type ;