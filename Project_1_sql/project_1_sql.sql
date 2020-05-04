call order_revenue ()
call date_revenue ()
call cus_revenue ()
call emp_revenue ()
call pro_revenue ()

/** drop table SaleFact
create table SaleFact
select r.orderNumber, c.customerNumber, c.salesRepEmployeeNumber, r.productCode, o.requiredDate,quantityOrdered,priceEach, priceEach*quantityOrdered as revenue
from OrderDetails as r
left join Orders as o 
on r.orderNumber = o.orderNumber
left join Customers as c 
on o.customerNumber = c.customerNumber


delimiter //

CREATE PROCEDURE order_revenue ()
BEGIN
  select orderNumber,sum(revenue) as total_rev
  from SaleFact
  -- where orderNumber = orderN
  group by orderNumber
  order by total_rev DESC;

END
delimiter;



delimiter //

CREATE PROCEDURE date_revenue ()
BEGIN
  select requiredDate,sum(revenue) as total_rev
  from SaleFact
  -- where orderNumber = orderN
  group by requiredDate
  order by total_rev DESC;

END
delimiter;



delimiter //

CREATE PROCEDURE emp_revenue ()
BEGIN
  select salesRepEmployeeNumber,sum(revenue) as total_rev
  from SaleFact
  -- where orderNumber = orderN
  group by salesRepEmployeeNumber
  order by total_rev DESC;

END
delimiter;



delimiter //

CREATE PROCEDURE cus_revenue ()
BEGIN
  select customerNumber,sum(revenue) as total_rev
  from SaleFact
  -- where orderNumber = orderN
  group by customerNumber
  order by total_rev DESC;

END
delimiter;

call cus_revenue ()

delimiter //

CREATE PROCEDURE pro_revenue ()
BEGIN
  select productCode,sum(revenue) as total_rev
  from SaleFact
  -- where orderNumber = orderN
  group by productCode
  order by total_rev DESC;

END
delimiter
**/

