--SQL Retail Sales Analysis
CREATE DATABASE sql_project_p2;

--CREATE TABLE
DROP TABLE IF EXISTS retail_sales;
CREATE TABLE retail_sales
             (
             transactions_id INT PRIMARY KEY,
             sale_date	DATE,
             sale_time	TIME,
             customer_id INT,
             gender VARCHAR(15),
             age INT,
             category VARCHAR(15),
             quantity INT,
             price_per_unit FLOAT,
             cogs  FLOAT,	
             total_sale FLOAT
             );

SELECT * FROM retail_sales;

SELECT COUNT(*) FROM retail_sales;

--Data Cleaning 
SELECT COUNT(customer_id) FROM retail_sales;

SELECT * FROM retail_sales
WHERE sale_date IS NULL;

SELECT * FROM retail_sales
WHERE sale_time IS NULL;

SELECT * FROM retail_sales
WHERE
transactions_id IS NULL
OR 
sale_date IS NULL
OR 
sale_time IS NULL
OR 
customer_id IS NULL
OR
gender IS NULL
OR 
age IS NULL
OR
category IS NULL
OR 
quantity IS NULL
OR 
price_per_unit IS NULL
OR
cogs IS NULL
OR 
total_sale IS NULL;

--
DELETE FROM retail_sales
WHERE
transactions_id IS NULL
OR 
sale_date IS NULL
OR 
sale_time IS NULL
OR 
customer_id IS NULL
OR
gender IS NULL
OR 
age IS NULL
OR
category IS NULL
OR 
quantity IS NULL
OR 
price_per_unit IS NULL
OR
cogs IS NULL
OR 
total_sale IS NULL;

--Data Exploration 
--How many sales we have?
SELECT COUNT(*) AS total_sale FROM retail_sales;

-- How many unique customer we have?
SELECT COUNT(DISTINCT customer_id) FROM retail_sales;

--Data Analysis & Business key Problems and Answers

--My Analysis and Findings
--1.Write a SQL query to retrieve all columns for sales made on '2022-11-05'
--2.Write a SQL query to retrieve all transactions where the category is 'Clothing' and the quantity sold is more than 4 in the month of Nov-2022
--3.Write a SQL query to calculate the total sales (total_sale) for each category.
--4.Write a SQL query to find the average age of customers who purchased items from the 'Beauty' category.
--5.Write a SQL query to find all transactions where the total_sale is greater than 1000.
--6.Write a SQL query to find the total number of transactions (transaction_id) made by each gender in each category.
--7.Write a SQL query to calculate the average sale for each month. Find out best selling month in each year:
--8.Write a SQL query to find the top 5 customers based on the highest total sales.
--9.Write a SQL query to find the number of unique customers who purchased items from each category.
--10.Write a SQL query to create each shift and number of orders (Example Morning <12, Afternoon Between 12 & 17, Evening >17)


--1.Write a SQL query to retrieve all columns for sales made on '2022-11-05'
SELECT * FROM retail_sales
WHERE sale_date = '2022-11-05';

--2.Write a SQL query to retrieve all transactions where the category is 'Clothing' and the quantity sold is at least 4 in the month of Nov-2022.
SELECT * FROM retail_sales
WHERE category ='Clothing' AND quantity>=4 AND TO_CHAR(sale_date, 'YYYY-MM') ='2022-11'
;

--3.Write a SQL query to calculate the total sales (total_sale) for each category.
SELECT category, SUM(total_sale) AS net_sale
FROM retail_sales
GROUP BY category;

--4.Write a SQL query to find the average age of customers who purchased items from the 'Beauty' category.
SELECT ROUND(AVG(age),2) As Average_age FROM retail_sales
WHERE category='Beauty'
GROUP BY category;

--5.Write a SQL query to find all transactions where the total_sale is greater than 1000.
SELECT * FROM retail_sales
WHERE total_sale>1000;

--6.Write a SQL query to find the total number of transactions (transaction_id) made by each gender in each category.
SELECT category,gender,COUNT(*) AS total_trans
FROM retail_sales
GROUP BY gender, category
ORDER BY 1;

--7.Write a SQL query to calculate the average sale for each month. Find out best selling month in each year
SELECT year,
month,
average_sale
FROM
(
SELECT 
EXTRACT(YEAR FROM sale_date) AS Year,
EXTRACT(MONTH FROM sale_date) AS Month,
AVG(total_sale)AS Average_sale,
RANK() OVER(PARTITION BY EXTRACT(YEAR FROM sale_date) ORDER BY AVG(total_sale)DESC) as rank 
FROM retail_sales
GROUP BY 1,2
) as T1
WHERE rank=1;

--8.Write a SQL query to find the top 5 customers based on the highest total sales.
SELECT customer_id, SUM(total_sale) as total_sale
FROM retail_sales
GROUP BY customer_id
ORDER BY 2 DESC
LIMIT 5;

--9.Write a SQL query to find the number of unique customers who purchased items from each category.
SELECT COUNT(DISTINCT customer_id) as unique_customer,category
FROM retail_sales
GROUP BY category;

--10.Write a SQL query to create each shift and number of orders (Example Morning <12, Afternoon Between 12 & 17, Evening >17)
WITH hourly_sale
AS(
SELECT *,
   CASE 
    WHEN EXTRACT(HOUR FROM sale_time)<12 THEN 'Morning'
	WHEN EXTRACT(HOUR FROM sale_time) BETWEEN 12 AND 17 THEN 'Afternoon'
    ELSE 'Evening'
END as Shift
FROM retail_sales
)
SELECT shift,
COUNT(*) as total_orders FROM hourly_sale
GROUP BY Shift;

--End of Project.





















