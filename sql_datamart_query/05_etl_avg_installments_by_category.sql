TRUNCATE TABLE avg_installments_by_category;
INSERT INTO avg_installments_by_category (product_category_name, avg_installments)
SELECT 
    p.product_category_name,
    AVG(fop.payment_installments) as avg_installments
FROM fact_order_payments fop
JOIN fact_order_items foi ON fop.order_key = foi.order_key
JOIN dim_products p ON foi.product_key = p.product_key
WHERE fop.payment_installments > 0 
  AND p.product_category_name IS NOT NULL
GROUP BY p.product_category_name
ORDER BY avg_installments DESC;