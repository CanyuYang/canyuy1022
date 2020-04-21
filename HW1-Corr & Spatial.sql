-- Correlated subqueries
-- Who reports to Mary Patterson?
select employeeNumber, firstName, lastName
from employees
where reportsTo = (select employeeNumber from employees where firstName = 'Mary' and lastName = 'Patterson');

-- Which payments in any month and year are more than twice the average for that month and year (i.e. compare all payments in Oct 2004 with the average payment for Oct 2004)? Order the results by the date of the payment. You will need to use the date functions.
drop temporary table ma
create temporary table ma as 
select  month(paymentDate) as mon, year(paymentDate) as y, avg(amount) as month_ave
from payments
group by mon, y

select paymentDate, amount, ma.mon, ma.y, month_ave
from payments,ma
where month(paymentDate) = ma.mon and  year (paymentDate) = ma.y and amount > 2*ma.month_ave
order by paymentDate

-- Report for each product, the percentage value of its stock on hand as a percentage of the stock on hand for product line to which it belongs. Order the report by product line and percentage value within product line descending. Show percentages with two decimal places.
drop temporary table line
create temporary table line as 
select productLine, productCode, quantityInStock, sum(quantityInStock) over (partition by productLine )as lineTotal
from products
group by productLine, quantityInStock
order by productLine, quantityInStock

select productLine, productCode, quantityInStock, round(quantityInStock/lineTotal * 100 ,2)as percentage
from line

-- For orders containing more than two products, report those products that constitute more than 50% of the value of the order.
create temporary table pro as 
select orderNumber,  sum(quantityOrdered*priceEach) as amount, count(*)
from orderdetails
group by orderNumber
having count(*) > 2

select r.orderNumber, productCode, (quantityOrdered*priceEach) as val, amount
from orderdetails as r
join pro using (orderNumber)
where quantityOrdered*priceEach > 0.5* amount


-- Spatial data
-- Which customers are in the Southern Hemisphere?
SELECT customerNumber, customerName
from Customers 
where ST_X(customerLocation) <0

-- Which US customers are south west of the New York office?
select customerNumber, customerName, city
from Customers
where ST_X(customerLocation) < (select distinct ST_X(customerLocation) from Customers where city = 'NYC')
and ST_Y(customerLocation)  not between (select distinct ST_Y(customerLocation) from Customers where city = 'NYC') and (select distinct ST_Y(customerLocation) from Customers where city = 'NYC') +180

-- Which customers are closest to the Tokyo office (i.e., closer to Tokyo than any other office)?
set @t = (select officeLocation from Offices where city = 'Tokyo')
select customerNumber,customerName, city, st_distance(customerLocation,@t)* 111195/1000 as distance
from customers
order by distance
limit 1

-- Which French customer is furthest from the Paris office?
set @p = (select officeLocation from Offices where city = 'Paris')
select customerNumber,customerName, city, st_distance(customerLocation,@p)* 111195/1000 as distance
from customers
order by distance DESC
limit 1

-- Who is the northernmost customer?
SELECT customerNumber, customerName, ST_X(customerLocation) 
from Customers 
order by  ST_X(customerLocation) DESC
limit 1

-- What is the distance between the Paris and Boston offices?
set @b = (select officeLocation from Offices where city = 'Boston')
set @p = (select officeLocation from Offices where city = 'Paris')

select ST_distance(@p,@b)* 111195/1000














