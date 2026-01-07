-- Create dimension table for customers --
CREATE TABLE dim_customers (
    customer_key SERIAL PRIMARY KEY,
    customer_unique_id CHAR(32),
    customer_zip_code_prefix CHAR(5),
    customer_city VARCHAR(50),
    customer_state CHAR(2)
);

-- Create dimension table for payments --
CREATE TABLE dim_payments (
    payment_type_key SERIAL PRIMARY KEY,
    payment_type_name VARCHAR(255) NOT NULL
);

-- Create dimension table for products --
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

-- Create dimension table for orders --
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

-- Create dimension table for sellers --
CREATE TABLE dim_sellers (
    seller_key SERIAL PRIMARY KEY,
    seller_id CHAR(32),
    seller_zip_code_prefix CHAR(5),
    seller_city VARCHAR(50),
    seller_state CHAR(2)
);

-- Create dimension table for dates --
CREATE TABLE dim_dates (
    date_key INT PRIMARY KEY,
    full_date DATE,
    day INT,
    month INT,
    year INT,
    quarter INT,
    day_of_week INT,
    is_weekend BOOLEAN
);

-- Create dimension table for reviews --
CREATE TABLE dim_reviews(
    review_key SERIAL PRIMARY KEY,
    review_id CHAR(32),
    review_score INT,
    review_response_time_days INT,
    review_response_speed_category VARCHAR(50)
);

