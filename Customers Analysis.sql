-- Data Manipulation & Exploration
SELECT * FROM customers_data;
-- count the distinct values in each column 
SELECT
    COUNT(DISTINCT Customer_ID) AS Distinct_Customer_ID,
    COUNT(DISTINCT Purchase_Date) AS Distinct_Purchase_Date,
    COUNT(DISTINCT Product_Category) AS Distinct_Product_Category,
    COUNT(DISTINCT Product_Price) AS Distinct_Product_Price,
    COUNT(DISTINCT Quantity) AS Distinct_Quantity,
    COUNT(DISTINCT Total_Purchase_Amount) AS Distinct_Total_Purchase_Amount,
    COUNT(DISTINCT Payment_Method) AS Distinct_Payment_Method,
    COUNT(DISTINCT Returns) AS Distinct_Returns,
    COUNT(DISTINCT Customer_Name) AS Distinct_Customer_Name,
    COUNT(DISTINCT Age) AS Distinct_Age,
    COUNT(DISTINCT Gender) AS Distinct_Gender,
    COUNT(DISTINCT Churn) AS Distinct_Churn
FROM customers_data;


RENAME TABLE customers.cutomers_data TO customers_data;

-- The calculated total purchase amount (Price * Quantity) in each transaction appears to differ from the value provided in the Total Purchase Amount field
-- This inconsistency may indicate inaccuracies within the dataset
ALTER TABLE customers_data 
ADD COLUMN Total_Amount decimal(10,2);

UPDATE customers_data
SET Total_Amount= Product_Price * Quantity;

SELECT Total_Amount From customers_data;

ALTER TABLE customers_data
DROP COLUMN Total_Purchase_Amount;

SELECT * FROM customers_data;





-- Explore Gender Demographics:-
-- 1. Gender Distribution 
-- Calculate count for each gender 
SELECT Gender, COUNT(*) as GenderCount
FROM customers_data
GROUP BY Gender;

-- 2. Purchase price distribution by gender
-- Calculate the percentage of total purchased amount for each gender
SELECT Gender,
FORMAT(SUM(Total_Amount),0) as TotalPurchaseAmount, -- formats the total_amount with commas 
ROUND(
SUM(Total_Amount)*100 / (SELECT SUM(Total_Amount) FROM customers_data) , 2)As Gender_Summary 
FROM customers_data 
GROUP BY Gender;

-- 3. Total Price Spent by each Gender, Breakdown by Year
SELECT Gender, 
year(Purchase_Date) As Year, -- Showing only the year from the column
AVG(Total_Amount) As Average_Spent_Price
FROM customers_data
GROUP BY Gender, Year
ORDER BY Year DESC;

-- 4. Customer churn and returns by gender
SELECT Gender,
SUM(Churn) As Churned_Customers,
SUM(Returns) As Returned_Customers,
CAST(SUM(Returns) * 1.0 / COUNT(*) *100 as decimal (10,2)) As Returns_Rate,
CAST(SUM(Churn) * 1.0 / COUNT(*) *100 as decimal (10,2)) As Churn_Rate
FROM customers_data
GROUP BY Gender
ORDER BY Churn_Rate DESC;


-- Explore Age Trends :-
-- 1. Age Distribution
-- Count each age group
SELECT CASE
 WHEN Age <= 9 THEN '0-9'
 WHEN Age <= 19 THEN '10-19'
 WHEN Age <= 29 THEN '20-29'
 WHEN Age <= 39 THEN '30-39'
 WHEN Age <= 49 THEN '40-49'
 WHEN Age <= 59 THEN '50-59'
 WHEN Age <= 69 THEN '60-69'
 ELSE '70+'
 END As Age_Bins,
 COUNT(*) As Age_Groups,
ROUND(COUNT(*) * 100.0 / (SELECT COUNT(*) FROM customers_data), 2) AS Percentage
FROM customers_data
GROUP BY Age_Bins
ORDER BY Age_Bins;


-- 2. Age Distribution By Gender 
-- count each age group by gender
SELECT CASE
 WHEN Age <= 9 THEN '0-9'
 WHEN Age <= 19 THEN '10-19'
 WHEN Age <= 29 THEN '20-29'
 WHEN Age <= 39 THEN '30-39'
 WHEN Age <= 49 THEN '40-49'
 WHEN Age <= 59 THEN '50-59'
 WHEN Age <= 69 THEN '60-69'
 ELSE '70+'
 END As Age_Bins,
 COUNT(*) As Age_Groups,
Gender
FROM customers_data
GROUP BY Age_Bins, Gender
ORDER BY Age_Bins;

-- 3. Average Price Spent By Age_Bins
 SELECT CASE
 WHEN Age <= 9 THEN '0-9'
 WHEN Age <= 19 THEN '10-19'
 WHEN Age <= 29 THEN '20-29'
 WHEN Age <= 39 THEN '30-39'
 WHEN Age <= 49 THEN '40-49'
 WHEN Age <= 59 THEN '50-59'
 WHEN Age <= 69 THEN '60-69'
 ELSE '70+'
 END As Age_Bins,
ROUND(AVG(Total_Amount),2) AS Average_Spent_Price
FROM customers_data
GROUP BY Age_Bins
ORDER BY Age_Bins;

-- 4. Customers Churn & Return By Age
SELECT  CASE
 WHEN Age <= 9 THEN '0-9'
 WHEN Age <= 19 THEN '10-19'
 WHEN Age <= 29 THEN '20-29'
 WHEN Age <= 39 THEN '30-39'
 WHEN Age <= 49 THEN '40-49'
 WHEN Age <= 59 THEN '50-59'
 WHEN Age <= 69 THEN '60-69'
 ELSE '70+'
 END As Age_Bins,
SUM(Churn) As Churned_Customers,
SUM(Returns) As Returned_Customers,
CAST(SUM(Returns) * 1.0 / COUNT(*) *100 as decimal (10,2)) As Returns_Rate,
CAST(SUM(Churn) * 1.0 / COUNT(*) *100 as decimal (10,2)) As Churn_Rate
FROM customers_data
GROUP BY Age_Bins
ORDER BY Age_Bins,Churn_Rate DESC;




-- Explore Products & Sales Trends:-
-- 1. Sales Revenue by Product Category
SELECT 
    Product_Category,
    year(Purchase_Date) As Year,
    SUM(Total_Amount) AS total_revenue
FROM 
    customers_data
GROUP BY 
    Product_Category, Year
ORDER BY 
    Year DESC, total_revenue DESC;


-- 2. Product revenue by Gender
SELECT 
    Product_Category,
    Gender,
    SUM(Total_Amount) AS total_revenue
FROM 
    customers_data
GROUP BY 
    Product_Category, Gender
ORDER BY 
  Product_Category, Gender, total_revenue DESC;

-- 3. Product revenue by Age Group
SELECT CASE
 WHEN Age <= 9 THEN '0-9'
 WHEN Age <= 19 THEN '10-19'
 WHEN Age <= 29 THEN '20-29'
 WHEN Age <= 39 THEN '30-39'
 WHEN Age <= 49 THEN '40-49'
 WHEN Age <= 59 THEN '50-59'
 WHEN Age <= 69 THEN '60-69'
 ELSE '70+'
 END As Age_Bins,
Product_Category,
SUM(Total_Amount) AS total_revenue
FROM customers_data
GROUP BY Product_Category, Age_Bins
ORDER BY Age_Bins;


-- 4. Total Monthly Sales by year
SELECT 
    YEAR(Purchase_Date) AS Year,
    MONTH(Purchase_Date) AS Month,
    SUM(Total_Amount) AS total_revenue
FROM 
    customers_data
GROUP BY 
    YEAR(Purchase_Date), MONTH(Purchase_Date)
ORDER BY 
     Year, Month;
     
-- 5. Monthly return and churn rate by year  
SELECT 
    DATE_FORMAT(purchase_date, '%Y-%m') AS purchase_date,
    AVG(returns) * 100 AS return_rate,
    AVG(churn) * 100 AS churn_rate
FROM 
    customers_data
GROUP BY 
    DATE_FORMAT(purchase_date, '%Y-%m')
ORDER BY 
    purchase_date;
    
    
-- 6. Payment Method by gender and age group
SELECT CASE
 WHEN Age <= 9 THEN '0-9'
 WHEN Age <= 19 THEN '10-19'
 WHEN Age <= 29 THEN '20-29'
 WHEN Age <= 39 THEN '30-39'
 WHEN Age <= 49 THEN '40-49'
 WHEN Age <= 59 THEN '50-59'
 WHEN Age <= 69 THEN '60-69'
 ELSE '70+'
 END As Age_Bins,
Gender,
Payment_Method
FROM customers_data
GROUP BY Payment_Method, Age_bins, Gender
ORDER BY Age_Bins, Payment_Method;