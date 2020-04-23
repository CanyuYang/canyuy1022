-- Regular expressions
-- Find products containing the name 'Ford'.
select productName
from  products
where productName like '%Ford%'

-- List products ending in 'ship'.
select productName
from  products
where productName REGEXP 'ship$'

-- Report the number of customers in Denmark, Norway, and Sweden.
select count(customerNumber)
from customers 
where country in ('Denmark', 'Norway', 'Sweden')

-- What are the products with a product code in the range S700_1000 to S700_1499?
select productName, productCode
from products
where productCode between 'S700_1000' and 'S700_1499'

-- Which customers have a digit in their name?
select customerName 
from customers
where customerName REGEXP '[0-9]'

-- List the names of employees called Dianne or Diane.
select employeeNumber, firstName,lastName
from employees
where firstName like '%Dianne%' or firstName like '%Diane%'

-- List the products containing ship or boat in their product name.
select productName
from products
where productName like '%ship%' or productName like '%boat%' 

-- List the products with a product code beginning with S700.
select productName, productCode
from products
where productCode regexp '^S700'

-- List the names of employees called Larry or Barry.
select employeeNumber, firstName,lastName
from employees
where firstName like '%Larry%' or firstName like '%Barry%'

-- List the names of employees with non-alphabetic characters in their names.
select  firstName,lastName
from employees
where firstName NOT REGEXP '[A-Za-z0-9]'
and lastName NOT REGEXP '[A-Za-z0-9]'

-- List the vendors whose name ends in Diecast
select *
from vendor
where firstname like '%Diecast'
or lastname like '%Diecast'


