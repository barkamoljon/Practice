-- create a temporary table to store the average total amount by sales rep
WITH sales_rep_avg AS (
  SELECT sales_rep_id, AVG(total_amt_usd) AS avg_sales_rep
  FROM orders
  GROUP BY sales_rep_id
)

-- create a temporary table to store the average total amount by region
WITH region_avg AS (
  SELECT r.id AS region_id, AVG(total_amt_usd) AS avg_region
  FROM orders o
  JOIN sales_reps s ON o.sales_rep_id = s.id
  JOIN region r ON s.region_id = r.id
  GROUP BY r.id
)

-- join the temporary tables with the sales reps and region tables and calculate the category based on the difference
SELECT s.name AS sales_rep_name, r.name AS region_name, a.avg_sales_rep, b.avg_region,
  CASE 
    WHEN a.avg_sales_rep - b.avg_region < -1000 THEN 'bad salesman'
    WHEN a.avg_sales_rep - b.avg_region BETWEEN -1000 AND 1000 THEN 'normal'
    ELSE 'good salesman'
  END AS category
FROM sales_reps s
JOIN region r ON s.region_id = r.id
JOIN sales_rep_avg a ON s.id = a.sales_rep_id
JOIN region_avg b ON r.id = b.region_id;
