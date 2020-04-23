-- Single entity
-- Prepare a list of offices sorted by country, state, city.
select officeCode, country, state, city
from offices

-- How many employees are there in the company?
select count(employeeNumber)
from employees

-- What is the total of payments received?
select sum(amount)
from payments

-- List the product lines that contain 'Cars'.
select * from productlines
where productLine like '%Cars'

-- Report total payments for October 28, 2004.
select sum(amount) from payments
where paymentDate = '2004-10-28'

-- Report those payments greater than $100,000.
select * from  payments
where amount > 100000

-- List the products in each product line.
select productLine,productCode
from products


-- How many products in each product line?
select productLine,count(distinct (productCode))
from products
group by productLine

-- What is the minimum payment received?
select min(amount)
from payments

-- List all payments greater than twice the average payment.
select *
from payments
where amount > (select 2* avg(amount) from payments)

-- What is the average percentage markup of the MSRP on buyPrice?
select avg(MSRP/buyPrice)
from products

-- How many distinct products does ClassicModels sell?
select count(distinct productCode)
from products

-- Report the name and city of customers who don't have sales representatives?
Select customerName, city
from customers
where salesRepEmployeeNumber is null

-- What are the names of executives with VP or Manager in their title? Use the CONCAT function to combine the employee's first name and last name into a single field for reporting.
Select CONCAT(firstName,  ' ' ,lastName) as full_name
from employees
where jobTitle like '%VP%' or 
 jobTitle like '%Manager%'
 
-- Which orders have a value greater than $5,000?
select orderNumber
from  (select orderNumber, sum(quantityOrdered*priceEach)  as total from orderdetails group by orderNumber) as val
where val.total > 5000