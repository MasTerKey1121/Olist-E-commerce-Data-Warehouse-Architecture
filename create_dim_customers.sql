CREATE TABLE dim_customers (
    customer_key SERIAL PRIMARY KEY,
    customer_unique_id CHAR(32),
    customer_zip_code_prefix CHAR(5),
    customer_city VARCHAR(50),
    customer_state CHAR(2)
);


INSERT INTO dim_customers (customer_unique_id, customer_zip_code_prefix, customer_city, customer_state)
SELECT DISTINCT 
    customer_unique_id,
    customer_zip_code_prefix,
    customer_city,
    customer_state
FROM staging_customers;
