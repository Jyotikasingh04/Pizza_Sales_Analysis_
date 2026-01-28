select * from pizza_sales

-- Total revenue generated
SELECT 
    SUM(total_price) AS total_revenue
FROM pizza_sales;

-- Total number of unique orders
SELECT 
    COUNT(DISTINCT order_id) AS total_orders
FROM pizza_sales;

-- Total pizzas sold
SELECT 
    SUM(quantity) AS total_pizzas_sold
FROM pizza_sales;

-- Average revenue per order
SELECT 
    AVG(order_total) AS avg_order_value
FROM (
    SELECT 
        order_id,
        SUM(total_price) AS order_total
    FROM pizza_sales
    GROUP BY order_id
) t;

-- Revenue percentage contribution by category
SELECT 
    pizza_category,
    SUM(total_price) AS revenue,
    ROUND(
        (SUM(total_price) * 100.0 / SUM(SUM(total_price)) OVER ())::NUMERIC,
        2
    ) AS revenue_percentage
FROM pizza_sales
GROUP BY pizza_category
ORDER BY revenue DESC;


-- Average number of pizzas per order
SELECT 
    AVG(pizza_count) AS avg_pizzas_per_order
FROM (
    SELECT 
        order_id,
        SUM(quantity) AS pizza_count
    FROM pizza_sales
    GROUP BY order_id
) t;

-- Revenue by pizza category
SELECT 
    pizza_category,
    SUM(total_price) AS revenue
FROM pizza_sales
GROUP BY pizza_category
ORDER BY revenue DESC;

-- Top 5 pizzas by revenue
SELECT 
    pizza_name,
    SUM(total_price) AS revenue
FROM pizza_sales
GROUP BY pizza_name
ORDER BY revenue DESC
LIMIT 5;

-- Weekday vs Weekend order comparison
SELECT 
    CASE 
        WHEN day_name IN ('Saturday', 'Sunday') THEN 'Weekend'
        ELSE 'Weekday'
    END AS day_type,
    COUNT(DISTINCT order_id) AS total_orders
FROM pizza_sales
GROUP BY day_type;


-- Monthly revenue trend
SELECT 
    month,
    SUM(total_price) AS monthly_revenue
FROM pizza_sales
GROUP BY month
ORDER BY month;

-- Orders with value higher than average order value
SELECT 
    order_id,
    SUM(total_price) AS order_value
FROM pizza_sales
GROUP BY order_id
HAVING SUM(total_price) > (
    SELECT AVG(order_total)
    FROM (
        SELECT 
            order_id,
            SUM(total_price) AS order_total
        FROM pizza_sales
        GROUP BY order_id
    ) t
);

