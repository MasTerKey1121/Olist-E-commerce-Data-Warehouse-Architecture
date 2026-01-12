TRUNCATE TABLE revenue_by_month;
INSERT INTO revenue_by_month (month_name, year, month, revenue)
SELECT 
    d.month_name,
    d.year,
    d.month,
    SUM(foi.price) as revenue
FROM fact_order_items foi
JOIN dim_orders dmo ON foi.order_key = dmo.order_key
JOIN dim_dates d ON dmo.order_purchase_date_key = d.date_key
GROUP BY d.month_name, d.year, d.month
ORDER BY d.year, d.month;