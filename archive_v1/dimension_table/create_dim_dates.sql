CREATE TABLE dim_dates (
    date_key INT PRIMARY KEY,      
    full_date DATE NOT NULL,      
    day INT NOT NULL,
    month INT NOT NULL,
    month_name VARCHAR(10), 
    quarter INT NOT NULL, 
    year INT NOT NULL,   
    day_of_week INT NOT NULL, 
    day_name VARCHAR(10), 
    is_weekend BOOLEAN 
);


INSERT INTO dim_dates
SELECT 
    TO_CHAR(datum, 'YYYYMMDD')::INT AS date_key,
    datum AS full_date,
    EXTRACT(DAY FROM datum) AS day,
    EXTRACT(MONTH FROM datum) AS month,
    TO_CHAR(datum, 'Month') AS month_name,
    EXTRACT(QUARTER FROM datum) AS quarter,
    EXTRACT(YEAR FROM datum) AS year,
    EXTRACT(ISODOW FROM datum) AS day_of_week,
    TO_CHAR(datum, 'Day') AS day_name,
    CASE WHEN EXTRACT(ISODOW FROM datum) IN (6, 7) THEN TRUE ELSE FALSE END AS is_weekend
FROM generate_series(
    '2016-01-01'::DATE, 
    '2019-12-31'::DATE, 
    '1 day'::INTERVAL
) AS datum;