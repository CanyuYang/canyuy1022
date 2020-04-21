-- General queries
-- Who is at the top of the organization (i.e.,  reports to no one).
Select *
from employees
where reportsTo is null

-- Who reports to William Patterson?
Select *
from employees
where reportsTo in (select employeeNumber from employees where lastname = 'Patterson' and firstname = 'William')

-- List all the products purchased by Herkku Gifts.
select r.productCode, o.customerNumber
from orderdetails as r
join orders as o
on r.orderNumber = o.orderNumber
where o.customerNumber = (select customerNumber from customers where customerName = 'Herkku Gifts')

-- Compute the commission for each sales representative, assuming the commission is 5% of the value of an order. Sort by employee last name and first name.
select c.salesRepEmployeeNumber, sum(0.05*quantityOrdered*priceEach) as commission
from customers as c
left join orders as o
on c.customerNumber = o.customerNumber
left join orderdetails as r
on o.orderNumber = r.orderNumber
group by c.salesRepEmployeeNumber

-- What is the difference in days between the most recent and oldest order date in the Orders file?
select DATEDIFF(max(orderDate),min(orderDate))
from orders

-- Compute the average time between order date and ship date for each customer ordered by the largest difference.
select customerNumber, avg(DATEDIFF(shippedDate,orderDate)) as diff
from orders
group by customerNumber
order by diff

-- What is the value of orders shipped in August 2004? (Hint).
select o.orderNumber,o.shippedDate, sum(r.quantityOrdered*r.priceEach) as value
from orders as o
left join orderdetails as r
on o.orderNumber = r.orderNumber
where o.shippedDate between '2004-08-01' AND '2004-08-31'
group by o.orderNumber,o.shippedDate

-- Compute the total value ordered, total amount paid, and their difference for each customer for orders placed in 2004 and payments received in 2004 (Hint; Create views for the total paid and total ordered).
drop view TT_ordered
create view TT_ordered as
select o.customerNumber,  sum(r.quantityOrdered*r.priceEach) as ttorder
from orders as o
join orderdetails as r
on o.orderNumber = r.orderNumber
where year(o.orderDate) = 2004
group by o.customerNumber

drop view TT_paid
create view TT_paid as
select o. customerNumber, sum(amount) as ttpaid
from orders as o
join payments as p
on o.customerNumber = p.customerNumber
where year(p.paymentDate) = 2004
group by o. customerNumber

select TT_ordered.customerNumber, ttpaid, ttorder, (ttpaid-ttorder) as diff
from  TT_ordered
inner join TT_paid
on TT_paid.customerNumber = TT_ordered.customerNumber 

-- List the employees who report to those employees who report to Diane Murphy. Use the CONCAT function to combine the employee's first name and last name into a single field for reporting.
select concat(firstName, ' ', lastName) as Name
from employees
where reportsTo in (
select employeeNumber
from employees 
where reportsTo = (select employeeNumber from employees where firstName = 'Diane'))

-- What is the percentage value of each product in inventory sorted by the highest percentage first (Hint: Create a view first).
create view prod as 
select sum(quantityInStock) as total
from products

select productCode, quantityInStock, quantityInStock/total as perct
from products, prod

-- Write a function to convert miles per gallon to liters per 100 kilometers.
DELIMITER 

CREATE FUNCTION MPGtoL100K(mpg decimal(10)) 
RETURNS decimal(10)
 DETERMINISTIC
  BEGIN
	 DECLARE lk decimal(10);
     set lk = (100 * 4.54609) /(1.609344 * mpg);
     RETURN  lk ;
     
  END

select MPGtoL100K(40)

-- Write a procedure to increase the price of a specified product category by a given percentage. You will need to create a product table with appropriate data to test your procedure. Alternatively, load the ClassicModels database on your personal machine so you have complete access. You have to change the DELIMITER prior to creating the procedure.
drop PROCEDURE price_inc
DELIMITER 
CREATE PROCEDURE price_inc(in productCode1 varchar(50), in perct decimal)
begin
   update products
   set MSRP = MSRP + (MSRP/100) * perct 
   where productCode = productCode1;
end

DELIMITER 
call price_inc('S10_1678', 10);
]
-- What is the ratio the value of payments made to orders received for each month of 2004. (i.e., divide the value of payments made by the orders received)?
drop view valuepo
create view valuepo as
select month(paymentDate) as month ,sum(p.amount) as vp, sum(r.priceEach*r.quantityOrdered) as vo
from orderdetails as r
join orders as o
on r.orderNumber = o.orderNumber
join payments as p
on p.customerNumber = o.customerNumber
where year(paymentDate) = 2004
group by month(paymentDate)
order by month(paymentDate)

select month , vp/vo as ratio
from valuepo

-- What is the difference in the amount received for each month of 2004 compared to 2003?
drop view amount03 
create view amount03 as 
select month(paymentDate) as month, sum(amount) as s03
from payments
where year(paymentDate) = 2003
group by month(paymentDate)
order by month

create view amount04 as 
select month(paymentDate) as month, sum(amount) as s04
from payments
where year(paymentDate) = 2004
group by month
order by month

select amount03.month, s03,s04,s04-s03 as diff
from amount03
join amount04
on amount03.month = amount04.month

-- Write a procedure to report the amount ordered in a specific month and year for customers containing a specified character string in their name.
drop PROCEDURE order_a
DELIMITER 
CREATE PROCEDURE order_a(in m int, in y int,in cha varchar(50))
begin

   select o.customerNumber, c.customerName, sum(r.quantityOrdered*r.priceEach) as order_amount
   from customers as c
   join orders as o
   on c.customerNumber = o.customerNumber
   join orderdetails as r
   on r.orderNumber = o.orderNumber
   where month(o.orderDate) = m and year(o.orderDate) = y and c.customerName like concat('%' ,cha,'%')
   group by o.customerNumber, c.customerName;

end

DELIMITER 
call order_a(1,2003, 'ea');
 
-- Write a procedure to change the credit limit of all customers in a specified country by a specified percentage.
drop PROCEDURE change_cl
DELIMITER 
CREATE PROCEDURE change_cl(in con varchar(50), in perct decimal)
begin
   update customers
   set creditLimit = creditLimit + (creditLimit/100) * perct 
   where country = con;
end

DELIMITER 
call price_inc('USA', 10);

-- Basket of goods analysis: A common retail analytics task is to analyze each basket or order to learn what products are often purchased together. Report the names of products that appear in the same order ten or more times.
/* drop view b2
create view b2 as
select r1.orderNumber as orderNumber,r1.productCode as p1, r2.productCode as p2, count(*)
from orderdetails as r1
join 
orderdetails as r2
on r1.orderNumber = r2.orderNumber
where r1.productCode !=r2.productCode
group by  r1.productCode, r2.productCode
having count(*) >=10

select b2.p1,b2.p2, r3.productCode as p3, count(*)
from b2
join 
orderdetails as r3
on r3.orderNumber = b2.orderNumber
where r3.productCode!= b2.p1
and r3.productCode != b2.p2
group by  b2.p1,b2.p2, r3.productCode
having count(*) >10 */

select r1.orderNumber as orderNumber,r1.productCode as p1, r2.productCode as p2, count(*)
from orderdetails as r1
join 
orderdetails as r2
on r1.orderNumber = r2.orderNumber
where r1.productCode !=r2.productCode
group by  r1.productCode, r2.productCode
having count(*) >=10

-- ABC reporting: Compute the revenue generated by each customer based on their orders. Also, show each customer's revenue as a percentage of total revenue. Sort by customer name.
CREATE TEMPORARY TABLE rev as 
(select distinct customerName, sum(quantityOrdered*priceEach) over( partition by customerName)as revenue, sum(quantityOrdered*priceEach) over() as total
from customers as c 
join orders as o
on o.customerNumber = c.customerNumber
join orderdetails as r
on r.orderNumber = o.orderNumber
order by customerName)

select customerName, revenue, revenue/ total as percentage
from rev
order by customerName

-- Compute the profit generated by each customer based on their orders. Also, show each customer's profit as a percentage of total profit. Sort by profit descending.
drop TEMPORARY TABLE profit
create TEMPORARY TABLE profit as 
(select distinct o.customerNumber as customerNumber, sum(r.quantityOrdered*(r.priceEach- p.buyPrice)) over(partition by o.customerNumber) as profit, sum(r.quantityOrdered*(r.priceEach- p.buyPrice))over() as total_profit
from products as p
join orderdetails as r
on r.productCode = p.productCode
join orders as o
on o.orderNumber = r.orderNumber)

select customerNumber, profit, profit/ total_profit as percentage
from profit
order by profit DESC

-- Compute the revenue generated by each sales representative based on the orders from the customers they serve.
select salesRepEmployeeNumber, sum(quantityOrdered*priceEach) as revenue
from customers as c
join orders as  o using (customerNumber)
join orderdetails as r using (orderNumber)
group by salesRepEmployeeNumber

-- Compute the profit generated by each sales representative based on the orders from the customers they serve. Sort by profit generated descending.
select c.salesRepEmployeeNumber, sum(r.quantityOrdered*(r.priceEach- p.buyPrice)) as profit
from customers as c
join orders as  o using (customerNumber)
join orderdetails as r using (orderNumber)
join products as p using (productCode)
group by salesRepEmployeeNumber

-- Compute the revenue generated by each product, sorted by product name.
select r.productCode, p.productName, sum(quantityOrdered*priceEach) as revenue
from orderdetails as r
join products as p using(productCode)
group by r.productCode, p.productName
order by p.productName

-- Compute the profit generated by each product line, sorted by profit descending.
select p.productLine,  sum(r.quantityOrdered*(r.priceEach- p.buyPrice)) as profit
from products as p
join orderdetails as r using (productCode)
group by p.productLine
order by profit

-- Same as Last Year (SALY) analysis: Compute the ratio for each product of sales for 2003 versus 2004.
select y1.productCode, y1.s03, y2.s04,y1.s03/y2.s04 as ratio
from
(select r.productCode as productCode, sum(quantityOrdered*priceEach) as s03
from orderdetails as r
join orders as o
on r.orderNumber = o.orderNumber
where year(orderDate) = 2003
group by r.productCode) as y1

join 
(select r.productCode as productCode, sum(quantityOrdered*priceEach) as s04
from orderdetails as r
join orders as o
on r.orderNumber = o.orderNumber
where year(orderDate) = 2004
group by r.productCode) as y2
on y1.productCode = y2.productCode

-- Compute the ratio of payments for each customer for 2003 versus 2004.
create view p03 as
select customerNumber, sum(amount) as t1
from payments
where year(paymentDate) = 2003
group by customerNumber

create view p04 as
select customerNumber, sum(amount) as t2
from payments
where year(paymentDate) = 2004
group by customerNumber

select p03.customerNumber, t1, t2, t1/t2 
from p03
join p04
on p03.customerNumber = p04.customerNumber

-- Find the products sold in 2003 but not 2004.
select r.productCode 
from orderdetails as r
join orders as o 
on r.orderNumber = o.orderNumber
where o.orderNumber not in (select distinct orderNumber from orders where year(orderDate) = '2004')
and o.orderNumber in (select distinct orderNumber from orders where year(orderDate) = '2003')

-- Find the customers without payments in 2003.
select distinct c.customerNumber
from customers as c
where c.customerNumber not in (select distinct customerNumber from payments where year(paymentDate) = '2003')






