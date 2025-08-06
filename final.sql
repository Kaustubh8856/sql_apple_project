 -- CREATING TABLES 
DROP TABLE IF EXISTS warranty;
DROP TABLE IF EXISTS sales;
DROP TABLE IF EXISTS products;
DROP TABLE IF EXISTS category;
DROP TABLE IF EXISTS stores;

CREATE TABLE stores(
store_id VARCHAR(5) PRIMARY KEY,
store_name VARCHAR(30) ,
city VARCHAR(25) ,
country VARCHAR(25) );

CREATE TABLE category
(category_id VARCHAR(10) PRIMARY KEY,
category_name VARCHAR(20));

CREATE TABLE products
(
product_id VARCHAR(10) PRIMARY KEY ,
product_name VARCHAR(35) ,
category_id VARCHAR(10) ,
launch_date date,
price FLOAT ,
CONSTRAINT fk_category FOREIGN KEY (category_id) REFERENCES category(category_id));

CREATE TABLE sales(
sale_id VARCHAR(15) PRIMARY KEY,
sale_date DATE,
store_id VARCHAR(10),
product_id VARCHAR(10),
quantity INT,
CONSTRAINT fk_store FOREIGN KEY (store_id) REFERENCES stores(store_id),
CONSTRAINT fk_product FOREIGN KEY (product_id) REFERENCES products(product_id));

CREATE TABLE warranty(
claim_id VARCHAR(10) PRIMARY KEY,
claim_date date ,
sale_id VARCHAR(15) ,
repair_status VARCHAR(15) ,
CONSTRAINT fk_orders FOREIGN KEY (sale_id) REFERENCES sales(sale_id) );

-- ALL TABLES CREATED AND IMPORTED

select * from category;
select * from products;
select * from stores;
select * from sales;
select * from warranty;

select distinct repair_status from warranty;

-- Improving query performance
-- ET: 72ms, PT: 0.08ms, Seq Scan
explain analyze 
select * from sales 
where product_id = 'P-43' 

create index sales_product_id on sales(product_id)
-- after creating index, the ET: 8ms, PT:1.04ms, Bitmap Index Scan
create index sales_store_id on sales(store_id)
create index sales_sale_date on sales(sale_date)


-- QUESTIONS

-- total number of units sold by each store
select s.store_id, s.store_name, sum(sa.quantity) as total_units_sold
from stores as s
join sales as sa on s.store_id = sa.store_id
group by 1,2
order by 3 desc


-- how many stores have never had a warranty claim
select count(*)
from stores where store_id
not in (
			select distinct(store_id) from
			sales as s
			right join
			warranty as w on 
			w.sale_id = s.sale_id  
)
-- all the stores have claimed a warranty


-- count number of unique products sold in last 3 years
select count(distinct( product_id)) 
from sales
where sale_date >= Current_Date - INTERVAL '1 year'


-- for each store, identify best selling day based on quantity
select * 
from
	(select 
		(store_id),
		to_char(sale_date, 'Day') as day_name,
		sum(quantity),
		rank() over(partition by store_id order by sum(quantity)) as rank
	from sales
	group by 1,2
	) 
where rank = 1


-- for each country identify the least selling product
select * 
from
	(select 
		st.country,
		sum(s.quantity) as least_qyt_sold,
		p.product_name,
		rank() over(partition by country,to_char(s.sale_date,'YYYY') order by sum(s.quantity)),
		to_char(s.sale_date,'YYYY')
	from sales as s
	join stores as st on st.store_id = s.store_id
	join products as p on p.product_id = s.product_id
	group by 1,3,5
	)
where rank = 1


-- warranty claims within 180 days of product sale
select s.sale_date, w.*, s.product_id
from sales as s
right join warranty as w on w.sale_id = s.sale_id 
where w.claim_date - s.sale_date <= 180


-- list months in last 3 years where sales exceeded 5000 units in United States
select 
	st.country,
	to_char(s.sale_date, 'MM-YYYY') as month,
	sum(s.quantity) as total_units
from sales as s 
join stores as st on st.store_id = s.store_id
where st.country = 'United States' and 
	s.sale_date >= current_date - interval '3 Year '		
group by 1,2
having sum(s.quantity) > 5000



-- percentage chance of rejection in warranty claim for each country
select 
	country,
	count(w.claim_id) as total_claims,
	count(w.claim_id) filter(where repair_status = 'Rejected') as Rejected_claims,
	Round(
	100* count(w.claim_id) filter(where repair_status = 'Rejected')/count(w.claim_id)
	,2) as Rejected_percent
from stores as st 
join sales as s on st.store_id = s.store_id
right join warranty as w on w.sale_id = s.sale_id
group by country


-- yearly growth of each store 
with 
	yearly_sales as(
		select 
			st.store_name,
			st.store_id,
			sum(p.price*s.quantity) as current_year_sales,
			extract(year from s.sale_date) as year
		from stores as st
		join sales as s on s.store_id  = st.store_id
		join products as p on p.product_id = s.product_id
		group by 1,2,4
					),
	growth_ratio as
			(select 
				store_id,
				store_name,
				year,
				current_year_sales,
				lag(current_year_sales,1) over(partition by store_name order by year) as prev_year_sales
			from yearly_sales)
		select
			store_id,
			store_name,
			year,
			current_year_sales,
			prev_year_sales,
			round((100*(current_year_sales-prev_year_sales)::numeric/prev_year_sales::numeric),3)
			 as growth_ratio
		from growth_ratio

-- relation between warranty and product price
select
	case
		when p.price < 500 then 'less expensive'
		when p.price between 500 and 1000 then 'mid-range'
		else 'expensive'
	end,	
	count(w.claim_id)
from warranty as w 
left join sales as s on s.sale_id = w.sale_id
join products as p on p.product_id = s.product_id
group by 1


 -- monthly running total of sales for each store
with monthly_sales as (
		select
		 	 s.store_id,
			 extract(year from s.sale_date) as year,
			 extract(month from s.sale_date) as month,
			 sum(p.price*s.quantity) as total_revenue
		from sales as s
		join products as p on p.product_id = s.product_id
		group by 1,2,3
		) 
select
	store_id, 
	year,
	month,
	total_revenue,
	sum(total_revenue) over(partition by store_id order by year,month) as running_total
from monthly_sales	



-- product sales trend over time 
select 
	p.product_name,
	case
		when sale_date between p.launch_date and p.launch_date + interval '6 month' then '0-6 month'
		when sale_date between p.launch_date + interval '6 month' and p.launch_date + interval '12 month' then '6-12 month'
		when sale_date between p.launch_date + interval '12 month' and p.launch_date + interval '18 month' then '12-18 month'
		else '18 above'
	end,	
	sum(s.quantity),
	case
        when sale_date between p.launch_date and p.launch_date + interval '6 month' then 1
        when sale_date between p.launch_date + interval '6 month' and p.launch_date + interval '12 month' then 2
        when sale_date between p.launch_date + interval '12 month' and p.launch_date + interval '18 month' then 3
        else 4
    end 
from products as p
join sales as s on s.product_id = p.product_id
group by 1,2,4
order by 1,4













