🛒 Retail Sales and Warranty Analysis – SQL Project
This project is a comprehensive SQL-based analytical pipeline designed to derive key business insights from a retail dataset. It simulates real-world data involving product sales, store locations, warranty claims, and product categories.

📂 Database Schema
The project consists of the following tables:

stores – Information about stores including location.
category – Product categories.
products – Product details including launch date and price.
sales – Transactions and quantities sold.
warranty – Warranty claims with repair status.

🔧 Features Implemented
Database Creation and Relationships: Designed normalized schema with proper foreign keys and constraints.
Performance Optimization: Created indexes on frequently queried fields like product_id, store_id, and sale_date to improve query execution time.

📊 Key Analyses Performed
Sales Overview
Total units sold by each store.
Unique products sold in the last 3 years.
Monthly running total of revenue per store.
Warranty Insights
Warranty claims within 180 days of sale.
Rejection percentage by country.
Correlation between product price range and warranty claims.
Temporal Trends
Product sales trend by lifetime buckets (0–6, 6–12, 12–18, 18+ months).
High-performing sales months in the US (sales > 5000 units).
Best selling day of the week per store.
Growth & Performance
Year-over-year revenue growth for each store.
Least selling product by country and year.

📈 Tools & Techniques Used
SQL Window Functions – RANK(), LAG(), SUM() OVER().
Aggregate Functions – SUM(), COUNT(), ROUND().
Date Operations – INTERVAL, EXTRACT(), TO_CHAR().
Subqueries & CTEs – For modular and readable logic.
Indexing – To enhance performance for large-scale queries.

🧠 Insights Derived
Identified sales patterns across different time windows since product launch.
Correlated pricing with warranty behavior.

Evaluated store and country-level performance across years.

