-- One to many relationship
-- Report the account representative for each customer.
select customerNumber, salesRepEmployeeNumber 
from customers

-- Report total payments for Atelier graphique.
select sum(amount)
from payments
where customerNumber = (select customerNumber from customers where customerName = 'Atelier graphique')

-- Report the total payments by date
select paymentDate, sum(amount)
from payments
group by paymentDate

-- Report the products that have not been sold.
select productCode 
from products
where productCode not in (select productCode from orderdetails)

-- List the amount paid by each customer.
select customerNumber, sum(amount)
from payments
group by customerNumber

-- How many orders have been placed by Herkku Gifts?
select count(orderNumber)
from orders
where customerNumber = (select customerNumber from customers where customerName = 'Herkku Gifts')

-- Who are the employees in Boston?
select employeeNumber, firstName, lastName
from employees
where officeCode = (select officeCode from offices where city = 'Boston')

-- Report those payments greater than $100,000. Sort the report so the customer who made the highest payment appears first.
select customerNumber,  amount
from payments
where amount > 100000
order by  amount DESC

-- List the value of 'On Hold' orders.
select orderNumber, sum(quantityOrdered*priceEach) as value
from orderdetails
where orderNumber in (select orderNumber from orders where status = 'on hold')
group by orderNumber

-- Report the number of orders 'On Hold' for each customer.
select customerNumber, count(orderNumber)
from orders
where status =  'On Hold'
group by  customerNumber

