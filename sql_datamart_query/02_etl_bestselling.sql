TRUNCATE TABLE best_selling;
INSERT INTO best_selling (product_category_name, revenue)
SELECT 
    p.product_category_name,
    SUM(foi.price) as revenue
FROM fact_order_items foi
JOIN dim_products p ON foi.product_key = p.product_key
WHERE p.product_category_name IS NOT NULL
GROUP BY p.product_category_name
ORDER BY revenue DESC;