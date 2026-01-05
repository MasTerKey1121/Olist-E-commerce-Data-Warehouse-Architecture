CREATE TABLE fact_order_reviews (
    order_review_key SERIAL PRIMARY KEY, 
    order_key INT NOT NULL,              
    review_key INT NOT NULL,             
    
    -- กำหนด Foreign Key Constraints เพื่อความถูกต้องของข้อมูล
    CONSTRAINT fk_fact_reviews_orders FOREIGN KEY (order_key) REFERENCES dim_orders (order_key),
    CONSTRAINT fk_fact_reviews_details FOREIGN KEY (review_key) REFERENCES dim_reviews (review_key)
);

INSERT INTO fact_order_reviews (order_key, review_key)
SELECT 
    dro.order_key,
    dr.review_key
FROM staging_order_reviews sor
JOIN dim_orders dro ON sor.order_id = dro.order_id
JOIN dim_reviews dr ON sor.review_id = dr.review_id;