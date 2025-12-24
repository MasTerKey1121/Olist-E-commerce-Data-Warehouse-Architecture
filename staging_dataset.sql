Create Table IF NOT EXISTS staging_customer (
    --"customer_id","customer_unique_id","customer_zip_code_prefix","customer_city","customer_state"
    customer_id CHAR(32),
    customer_unique_id CHAR(32),
    customer_zip_code_prefix CHAR(5),
    customer_city VARCHAR(50),
    customer_state CHAR(2)
);

COPY staging_customer 
FROM '/datasets/olist_customers_dataset.csv' 
DELIMITER ',' CSV HEADER; 

Create Table IF NOT EXISTS staging_geolocation(
    --"geolocation_zip_code_prefix","geolocation_lat","geolocation_lng","geolocation_city","geolocation_state"
    geolocation_zip_code_prefix CHAR(5),
    geolocation_lat FLOAT,
    geolocation_lng FLOAT,
    geolocation_city VARCHAR(50),
    geolocation_state CHAR(2)
);

COPY staging_geolocation
FROM '/datasets/olist_geolocation_dataset.csv'
DELIMITER ',' CSV HEADER;

Create TABLE IF NOT EXISTS staging_order_items(
    --"order_id","order_item_id","product_id","seller_id","shipping_limit_date","price","freight_value"
    order_id CHAR(32),
    order_item_id INT,
    product_id CHAR(32),
    seller_id CHAR(32),
    shipping_limit_date TIMESTAMP,
    price FLOAT,
    freight_value FLOAT
);

COPY staging_order_items
FROM '/datasets/olist_order_items_dataset.csv'
DELIMITER ',' CSV HEADER;


CREATE TABLE IF NOT EXISTS staging_order_payments(
    --"order_id","payment_sequential","payment_type","payment_installments","payment_value"
    order_id CHAR(32),
    payment_sequential INT,
    payment_type VARCHAR(20),
    payment_installments INT,
    payment_value FLOAT
);

COPY staging_order_payments
FROM '/datasets/olist_order_payments_dataset.csv'
DELIMITER ',' CSV HEADER;


CREATE TABLE IF NOT EXISTS staging_order_reviews(
    --"review_id","order_id","review_score","review_comment_title","review_comment_message","review_creation_date","review_answer_timestamp"
    review_id CHAR(32),
    order_id CHAR(32),
    review_score INT,
    review_comment_title VARCHAR(255),
    review_comment_message TEXT,
    review_creation_date TIMESTAMP,
    review_answer_timestamp TIMESTAMP
);

COPY staging_order_reviews
FROM '/datasets/olist_order_reviews_dataset.csv'
DELIMITER ',' CSV HEADER;

CREATE TABLE IF NOT EXISTS staging_orders(
    --"order_id","customer_id","order_status","order_purchase_timestamp","order_approved_at","order_delivered_carrier_date","order_delivered_customer_date","order_estimated_delivery_date"
    order_id CHAR(32),
    customer_id CHAR(32),
    order_status VARCHAR(20),
    order_purchase_timestamp TIMESTAMP,
    order_approved_at TIMESTAMP,
    order_delivered_carrier_date TIMESTAMP,
    order_delivered_customer_date TIMESTAMP,
    order_estimated_delivery_date TIMESTAMP
);

COPY staging_orders
FROM '/datasets/olist_orders_dataset.csv'
DELIMITER ',' CSV HEADER;

CREATE TABLE IF NOT EXISTS staging_products(
    --"product_id","product_category_name","product_name_lenght","product_description_lenght","product_photos_qty","product_weight_g","product_length_cm","product_height_cm","product_width_cm"
    product_id CHAR(32),
    product_category_name VARCHAR(100),
    product_name_lenght INT,
    product_description_lenght INT,
    product_photos_qty INT,
    product_weight_g FLOAT,
    product_length_cm FLOAT,
    product_height_cm FLOAT,
    product_width_cm FLOAT
);

COPY staging_products
FROM '/datasets/olist_products_dataset.csv'
DELIMITER ',' CSV HEADER;

CREATE TABLE IF NOT EXISTS staging_sellers(
    --"seller_id","seller_zip_code_prefix","seller_city","seller_state"
    seller_id CHAR(32) PRIMARY KEY,
    seller_zip_code_prefix CHAR(5),
    seller_city VARCHAR(50),
    seller_state CHAR(2)
);

COPY staging_sellers
FROM '/datasets/olist_sellers_dataset.csv'
DELIMITER ',' CSV HEADER;

CREATE TABLE IF NOT EXISTS staging_category_name_translation(
    --"product_category_name","product_category_name_english"
    product_category_name VARCHAR(100) PRIMARY KEY,
    product_category_name_english VARCHAR(100)
);

COPY staging_category_name_translation
FROM '/datasets/product_category_name_translation.csv'
DELIMITER ',' CSV HEADER;

