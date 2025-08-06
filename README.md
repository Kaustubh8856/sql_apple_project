# 🛒 Retail Sales and Warranty Analysis – SQL Project

This project is a comprehensive **SQL-based analytical pipeline** designed to derive key business insights from a retail dataset. It simulates real-world data involving **product sales**, **store locations**, **warranty claims**, and **product categories**.

---

## 📂 Database Schema

The project is built on a normalized relational schema consisting of the following tables:

- **`stores`** – Contains store details including their location (country, region, tier).
- **`category`** – Stores product category and sub-category information.
- **`products`** – Includes product-level details such as name, launch date, and price.
- **`sales`** – Represents transactions including quantity sold, date, store, and product.
- **`warranty`** – Tracks warranty claims, claim dates, and repair status (e.g., Approved, Rejected).

---

## 🔧 Features Implemented

- ✅ **Database Design & Relationships**  
  Designed a normalized schema with foreign key constraints to maintain referential integrity.

---

## 🚀 Performance Optimization

Created indexes on high-traffic fields like:

- `product_id`  
- `store_id`  
- `sale_date`  

...to significantly improve query execution time.

---

## 📊 Key Analyses Performed

### 🛍️ Sales Overview

- Total units sold by each store.
- Count of unique products sold in the last 3 years.
- Monthly running total of revenue per store.

### 🛠️ Warranty Insights

- Warranty claims filed within 180 days of sale.
- Rejection percentage of warranty claims by country.
- Correlation between product price ranges and warranty issues.

### 📆 Temporal Trends

- Product sales distribution over lifecycle: `0–6`, `6–12`, `12–18`, `18+` months.
- Identification of top-performing months in the US (based on sales volume > 5000 units).
- Determined the best-selling day of the week per store.

### 📈 Growth & Performance

- Year-over-year revenue growth for each store.
- Identified least-selling product by country and year.

---

## ⚙️ Tools & Techniques Used

- **SQL Window Functions** – `RANK()`, `LAG()`, `SUM() OVER()`
- **Aggregate Functions** – `SUM()`, `COUNT()`, `ROUND()`
- **Date Operations** – `INTERVAL`, `EXTRACT()`, `TO_CHAR()`
- **Subqueries & CTEs** – For modular and readable logic
- **Indexing** – For enhanced performance in large-scale queries

---

## 🧠 Insights Derived

- Uncovered **sales patterns** across multiple time windows since product launch.
- Established correlation between **pricing and warranty claim behavior**.
- Evaluated **store-level** and **country-level performance** trends over time.
