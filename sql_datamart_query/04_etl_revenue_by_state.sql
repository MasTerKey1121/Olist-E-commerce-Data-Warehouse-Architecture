TRUNCATE TABLE revenue_by_state;
INSERT INTO revenue_by_state (customer_state, revenue)
SELECT 
    c.customer_state,
    SUM(foi.price) as revenue
FROM fact_order_items foi
JOIN dim_orders dmo ON foi.order_key = dmo.order_key
JOIN dim_customers c ON dmo.customer_key = c.customer_key
GROUP BY   c.customer_state
ORDER BY c.customer_state;