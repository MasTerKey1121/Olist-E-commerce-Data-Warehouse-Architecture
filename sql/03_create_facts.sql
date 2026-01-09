-- Create fact table for order items --
CREATE TABLE fact_order_items (
    order_item_key SERIAL PRIMARY KEY,
    order_key INT NOT NULL,
    product_key INT NOT NULL,
    seller_key INT NOT NULL,
    shipping_limit_date TIMESTAMP NOT NULL,
    price NUMERIC(10,2) NOT NULL,
    freight_value NUMERIC(10,2) NOT NULL,

    CONSTRAINT fk_fact_items_orders FOREIGN KEY (order_key) REFERENCES dim_orders (order_key),
    CONSTRAINT fk_fact_items_products FOREIGN KEY (product_key) REFERENCES dim_products (product_key),
    CONSTRAINT fk_fact_items_sellers FOREIGN KEY (seller_key) REFERENCES dim_sellers (seller_key)
);


-- Create fact table for order payments --
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


-- Create fact table for order reviews --
CREATE TABLE fact_order_reviews (
    order_review_key SERIAL PRIMARY KEY, 
    order_key INT NOT NULL,              
    review_key INT NOT NULL,             
    
    CONSTRAINT fk_fact_reviews_orders FOREIGN KEY (order_key) REFERENCES dim_orders (order_key),
    CONSTRAINT fk_fact_reviews_details FOREIGN KEY (review_key) REFERENCES dim_reviews (review_key)
);