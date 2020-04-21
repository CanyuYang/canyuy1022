-- Many to many relationship
-- List products sold by order date.
select orderDate, productCode
from orderdetails
inner join orders
on orderdetails.orderNumber = orders.orderNumber
order by orderDate

-- List the order dates in descending order for orders for the 1940 Ford Pickup Truck.
select orderDate
from orders 
join orderdetails
on orderdetails.orderNumber = orders.orderNumber
where productCode = (select productCode from products where productName = '1940 Ford Pickup Truck')
order by orderDate DESC

-- List the names of customers and their corresponding order number where a particular order from that customer has a value greater than $25,000?
select  c.customerNumber, c.customerName,o.orderNumber, sum(o.quantityOrdered*o.priceEach) as value
from orderdetails as o
left join orders as r
on o.orderNumber = r.orderNumber
left join customers as c
on r.customerNumber = c.customerNumber
group by c.customerName, o.orderNumber
having value > 25000

-- Are there any products that appear on all orders? @@
select productCode, count(productCode)
from orderdetails
group by productCode
having count(productCode)> count(distinct orderNumber)

-- List the names of products sold at less than 80% of the MSRP.
select distinct p.productName, p.productCode
from products as p
left join orderdetails as o
on p.productCode = o.productCode
where o.priceEach/p.MSRP < 0.8

-- Reports those products that have been sold with a markup of 100% or more (i.e.,  the priceEach is at least twice the buyPrice)
select distinct p.productName, p.productCode
from products as p
left join orderdetails as o
on p.productCode = o.productCode
where o.priceEach/p.buyPrice >1

-- List the products ordered on a Monday.
select p.productCode, p.productName,r.orderNumber, o.orderDate
from products as p
inner join orderdetails as r
on p.productCode = r.productCode
left join orders as o
on r.orderNumber = o.orderNumber
WHERE dayofweek(o.orderDate) = 1

-- What is the quantity on hand for products listed on 'On Hold' orders?
select r.productCode, o.status, count(r.productCode)
from orderdetails as r
inner join orders as o
on r.orderNumber = o.orderNumber
where o.status = 'on hold'
group by r.productCode
