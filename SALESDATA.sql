# Revenue & Sales Performance
use anshika;
select* from sales_data_sample;

#Total sales revenue by year, quarter, and month
#By year
select sum(SALES),YEAR_ID from sales_data_sample group by YEAR_ID;
#BY  QUARTER
select sum(SALES), MONTH_ID from sales_data_sample group by  MONTH_ID ;
#by QUARTER
select sum(SALES), QTR_ID from sales_data_sample group by  QTR_ID ;
#Average deal value by deal size (Small, Medium, Large)
SELECT 
    DEALSIZE,
    COUNT(*) as Number_of_Deals,
    AVG(SALES) as Average_Deal_Value,
    MIN(SALES) as Minimum_Deal_Value,
    MAX(SALES) as Maximum_Deal_Value,
    SUM(SALES) as Total_Revenue,
    ROUND(SUM(SALES) * 100.0 / (SELECT SUM(SALES) FROM sales_data_sample), 2) as Revenue_Percentage
FROM sales_data_sample
GROUP BY DEALSIZE
ORDER BY Average_Deal_Value DESC;
#Sales trends over time
select sum(SALES),YEAR_ID from sales_data_sample group by YEAR_ID;
#Price vs MSRP analysis (profit margin calculation
SELECT 
    PRODUCTLINE,
    COUNT(*) as Number_of_Orders,
    SUM(SALES) as Total_Revenue,
    SUM(QUANTITYORDERED * MSRP) as Total_Cost,
    SUM(SALES) - SUM(QUANTITYORDERED * MSRP) as Total_Profit,
    ROUND((SUM(SALES) - SUM(QUANTITYORDERED * MSRP)) / SUM(SALES) * 100, 2) as Profit_Margin_Percent,
    ROUND(AVG(PRICEEACH - MSRP), 2) as Avg_Profit_Per_Unit
FROM sales_data_sample
GROUP BY PRODUCTLINE
ORDER BY Profit_Margin_Percent DESC;
------#2. Product Performance
#Revenue by product line
SELECT 
    PRODUCTLINE,
    SUM(SALES) as Total_Revenue,
    COUNT(*) as Number_of_Orders,
    ROUND(AVG(SALES), 2) as Avg_Order_Value,
    SUM(QUANTITYORDERED) as Total_Units_Sold,
    ROUND(SUM(SALES) * 100.0 / (SELECT SUM(SALES) FROM sales_data_sample), 2) as Revenue_Percentage
FROM sales_data_sample
GROUP BY PRODUCTLINE
ORDER BY Total_Revenue DESC;
#Quantity ordered vs Revenue (which products sell high volume?)
SELECT 
PRODUCTLINE,
      COUNT(*)as number_of_orders,
      sum(SALES) AS total_revenue,
      COUNT(QUANTITYORDERED)as units_sold
FROM sales_data_sample
group by PRODUCTLINE
ORDER BY total_revenue DESC;
------#Classic cars sells much higher as compared to vintage ones----
#Product profitability (SALES - (QUANTITYORDERED * (PRICEEACH - MSRP)))
select 
      PRODUCTLINE,
      sum(SALES) as total_sales,
      sum(QUANTITYORDERED) as units_sold,
      ROUND(SUM(SALES)- (SELECT SUM(QUANTITYORDERED) FROM sales_data_sample)*((SELECT SUM(PRICEEACH) FROM sales_data_sample)-(SELECT SUM(MSRP) FROM sales_data_sample)), 2)
      AS product_profitability
FROM sales_data_sample
group by PRODUCTLINE
ORDER BY units_sold DESC;
------#Best-selling products (by quantity and revenue)
SELECT 
      PRODUCTLINE,
      sum(QUANTITYORDERED) AS Units_sold,
      sum(SALES) as Total_revenue
FROM sales_data_sample
group by PRODUCTLINE
ORDER BY Total_revenue DESC;
----# Customer Insights
-----#Top 10 customers by revenue
SELECT
      CUSTOMERNAME,
      ROUND(SUM(SALES),2) AS total_revenue,
      SUM(QUANTITYORDERED) as Units_sold,
      MIN(ORDERDATE) as First_Order_Date,
      MAX(ORDERDATE) as Last_Order_Date,
      DATEDIFF(MAX(ORDERDATE), MIN(ORDERDATE)) as Days_as_Customer
FROM sales_data_sample
group by CUSTOMERNAME
ORDER BY total_revenue DESC
LIMIT 10;
-------#Customer distribution by country/territory
-- Revenue by Country with Customer Metrics
SELECT 
    COUNTRY,
    SUM(SALES) as Total_Revenue,
    COUNT(*) as Total_Orders,
    COUNT(DISTINCT CUSTOMERNAME) as Unique_Customers,
    ROUND(AVG(SALES), 2) as Avg_Order_Value,
    ROUND(SUM(SALES) * 100.0 / (SELECT SUM(SALES) FROM sales_data_sample), 2) as Revenue_Percentage,
    MIN(ORDERDATE) as First_Order,
    MAX(ORDERDATE) as Last_Order,
    SUM(QUANTITYORDERED) as Total_Units
FROM sales_data_sample
GROUP BY COUNTRY
ORDER BY Total_Revenue DESC;
----#Average order value per customer
SELECT 
    CUSTOMERNAME,
    ROUND(AVG(SALES), 2) AS avg_order_value,
    COUNT(*) AS Total_Orders,
    SUM(SALES) AS Total_revenue
FROM
    sales_data_sample
GROUP BY CUSTOMERNAME
ORDER BY Total_revenue DESC;
-----#Customer acquisition by year
#Repeat customers vs one-time buyers
SELECT 
      CUSTOMERNAME,
      COUNT(*) AS number_of_orders,
      count(Distinct CUSTOMERNAME)AS One_time_customer
FROM sales_data_sample
GROUP BY CUSTOMERNAME
ORDER BY number_of_orders DESC;
---#Q1: What are the top 5 best-selling product lines by total revenue?
SELECT 
    PRODUCTLINE,
    SUM(SALES) as Total_Revenue,
    COUNT(*) as Number_of_Orders
FROM sales_data_sample
GROUP BY PRODUCTLINE
ORDER BY Total_Revenue DESC
LIMIT 5;
#----Q2: Which country has the highest average order value?
SELECT 
    PRODUCTLINE,
    SUM(SALES) as Total_Revenue,
    COUNT(*) as Number_of_Orders
FROM sales_data_sample
GROUP BY PRODUCTLINE
ORDER BY Total_Revenue DESC
LIMIT 5;
#Sales by country and territory      
SELECT
	 COUNTRY,
     round(SUM(SALES),2) AS total_revenue,
     COUNT(*)AS number_of_orders,
     count(DISTINCT CUSTOMERNAME) AS unique_customer
FROM sales_data_sample
group by COUNTRY
ORDER BY total_revenue DESC;
----#Revenue distribution across regions (NA, EMEA, APAC)
SELECT
	  TERRITORY,
      ROUND(sum(SALES),2) as Total_revenue,
      count(*) as Number_of_orders,
      count(DISTINCT CUSTOMERNAME) AS Uninque_customer
FROM sales_data_sample
group by TERRITORY
ORDER BY Total_revenue DESC;
#---Top cities/states by sales
SELECT
	  CITY,
      ROUND(sum(SALES),2) as total_revenue,
      count(*) as number_of_orders,
      sum(QUANTITYORDERED) as Unit_sold,
      count(distinct CUSTOMERNAME) as unique_customer
      
FROM sales_data_sample
group by CITY
ORDER BY total_revenue DESC
LIMIT 5;
#5. Order Management
#-----Order fulfillment status breakdown
SELECT 
    STATUS,
    COUNT(*) as Number_of_Orders,
    ROUND(COUNT(*) * 100.0 / (SELECT COUNT(*) FROM sales_data_sample), 2) as Order_Percentage,
    SUM(SALES) as Total_Revenue,
    ROUND(SUM(SALES) * 100.0 / (SELECT SUM(SALES) FROM sales_data_sample), 2) as Revenue_Percentage,
    SUM(QUANTITYORDERED) as Total_Units,
    ROUND(AVG(SALES), 2) as Avg_Order_Value,
    ROUND(MIN(SALES), 2) as Min_Order_Value,
    ROUND(MAX(SALES), 2) as Max_Order_Value,
    ROUND(STDDEV(SALES), 2) as Std_Dev_Order_Value
FROM sales_data_sample
GROUP BY STATUS
ORDER BY NUMBER_OF_ORDERS DESC;

#----
SELECT 
    STATUS,PRODUCTLINE,
    COUNT(*) as Number_of_Orders,
    ROUND(COUNT(*) * 100.0 / (SELECT COUNT(*) FROM sales_data_sample), 2) as Order_Percentage,
    ROUND(SUM(SALES),2) as Total_Revenue,
    ROUND(SUM(SALES) * 100.0 / (SELECT SUM(SALES) FROM sales_data_sample), 2) as Revenue_Percentage,
    SUM(QUANTITYORDERED) as Total_Units
FROM sales_data_sample
WHERE  STATUS IN('Cancelled','Disputed')
GROUP BY PRODUCTLINE, STATUS
ORDER BY Total_units desc

      
      