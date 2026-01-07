CREATE TABLE dim_reviews(
    review_key SERIAL PRIMARY KEY,
    review_id CHAR(32),
    review_score INT,
    review_response_time_days INT,
    review_response_speed_category VARCHAR(50)
);



INSERT INTO dim_reviews (
    review_id, 
    review_score, 
    review_response_time_days,
    review_response_speed_category
)
SELECT 
    review_id,
    review_score,
    DATE_PART('day', review_answer_timestamp - review_creation_date) AS response_time_days,
    CASE 
        WHEN review_answer_timestamp IS NULL THEN 'No Response'
        WHEN DATE_PART('day', review_answer_timestamp - review_creation_date) <= 1 THEN 'Fast' --response within 1 day
        WHEN DATE_PART('day', review_answer_timestamp - review_creation_date) <= 3 THEN 'Normal' --response within 3 days
        ELSE 'Slow' --response more than 3 days
    END AS response_speed_category
from staging_order_reviews;
