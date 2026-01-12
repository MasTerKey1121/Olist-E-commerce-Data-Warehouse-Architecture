TRUNCATE TABLE frequently_bought_together;
INSERT INTO frequently_bought_together (product_category_a, product_category_b, pair_count)
WITH order_items_clean AS (
    SELECT DISTINCT foi.order_key, p.product_category_name
    FROM fact_order_items foi
    JOIN dim_products p ON foi.product_key = p.product_key
    WHERE p.product_category_name IS NOT NULL
)
SELECT 
    a.product_category_name AS product_category_a,
    b.product_category_name AS product_category_b,
    COUNT(*) AS pair_count
FROM order_items_clean a
JOIN order_items_clean b ON a.order_key = b.order_key
WHERE a.product_category_name < b.product_category_name 
GROUP BY a.product_category_name, b.product_category_name
ORDER BY pair_count DESC
LIMIT 100;