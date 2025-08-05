create database retail_sales_analysis;

select distinct count(order_id) from orders;

# Total revenue, total orders, and total customers

SELECT SUM(od.quantity * p.price * (1 - od.discount)) AS total_revenue,
 count(distinct c.customer_id) as total_customers,
 COUNT(DISTINCT o.order_id) AS total_orders
 FROM Order_Details od
 JOIN Orders o ON od.order_id = o.order_id
 join customers c on o.customer_id = c.customer_id 
 JOIN Products p ON od.product_id = p.product_id;
 
 # Top 10 best-selling products
 
 SELECT p.product_name, SUM(od.quantity) AS total_quantity
 FROM Order_Details od
 JOIN Products p ON od.product_id = p.product_id
 GROUP BY p.product_name
 ORDER BY total_quantity DESC
 LIMIT 10;
 
 select * from orders;
 
 # Monthly revenue trend for the last 12 months
 
 SELECT DATE_FORMAT(o.order_date, '%Y-%m') AS month,
 SUM(od.quantity * p.price * (1 - od.discount)) AS revenue
 FROM Orders o
 JOIN Order_Details od ON o.order_id = od.order_id
 JOIN Products p ON od.product_id = p.product_id
GROUP BY month
 ORDER BY month desc limit 12;

# Average order value per customer

SELECT
  c.customer_id,
  c.name,
  ROUND(SUM(od.quantity * p.price * (1 - od.discount)) / COUNT(DISTINCT o.order_id), 2) AS avg_order_value
FROM Customers c
JOIN Orders o ON c.customer_id = o.customer_id
JOIN Order_Details od ON o.order_id = od.order_id
JOIN Products p ON od.product_id = p.product_id
GROUP BY c.customer_id, c.name
ORDER BY avg_order_value DESC;

# Top 5 customers by revenue

select c.customer_id,
c.name,
SUM(od.quantity * p.price * (1 - od.discount)) AS revenue
  FROM Orders o
 JOIN Order_Details od ON o.order_id = od.order_id
 JOIN Products p ON od.product_id = p.product_id
 join customers c on o.customer_id = c.customer_id
GROUP BY c.customer_id, c.name
order by revenue desc
 limit 5;
 
 -- Sales contribution by region

SELECT
  o.region,
  SUM(od.quantity * p.price * (1 - od.discount)) AS region_revenue,
  ROUND(SUM(od.quantity * p.price * (1 - od.discount)) / 
        (SELECT SUM(od2.quantity * p2.price * (1 - od2.discount))
         FROM Order_Details od2
         JOIN Products p2 ON od2.product_id = p2.product_id) * 100, 2) AS contribution_percent
FROM Orders o
JOIN Order_Details od ON o.order_id = od.order_id
JOIN Products p ON od.product_id = p.product_id
GROUP BY o.region
ORDER BY region_revenue DESC;

# Products with the highest discount usage

SELECT
  p.product_name,
  COUNT(*) AS discount_count,
  SUM(od.quantity * p.price * od.discount) AS total_discount_value
FROM Order_Details od
JOIN Products p ON od.product_id = p.product_id
WHERE od.discount > 0
GROUP BY p.product_name
ORDER BY discount_count DESC
LIMIT 10;

# Category-wise sales and profit

SELECT
  p.category,
  SUM(od.quantity * p.price * (1 - od.discount)) AS total_sales,
  SUM(od.quantity * p.price * (1 - od.discount)) * 0.25 AS estimated_profit
FROM Order_Details od
JOIN Products p ON od.product_id = p.product_id
GROUP BY p.category
ORDER BY total_sales DESC;


 