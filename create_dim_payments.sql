CREATE TABLE dim_payments (
    payment_type_key SERIAL PRIMARY KEY,
    payment_type_name VARCHAR(255) NOT NULL
);


INSERT INTO dim_payments (payment_type_name)
SELECT payment_type 
from staging_order_payments
GROUP BY payment_type
ORDER BY count(*) DESC;

