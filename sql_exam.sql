-- 1
select city, count(*) as employee_count
from Employees
join offices using (officeCode)
group by city
order by  employee_count desc
limit 3

-- 2
select productLine, (sum(MSRP)-sum(buyPrice))/sum(MSRP) as profit_margin
from Products
group by productLine

-- 3
select employeeNumber, firstName, lastName, sum(quantityOrdered*priceEach) as revenue
from Employees as e
join Customers  as c
on c.salesRepEmployeeNumber = e.employeeNumber
join orders using (customerNumber)
join OrderDetails using (orderNumber)
group by employeeNumber
order by revenue desc
limit 3

-- update Employees table   set jobtitle = Sales Manager (), reportsTo = 1056

delimiter 
create procedure emp_l(in en int)
begin
 delete from Employees
 where employeeNumber = en;

 update Customers 
 set salesRepEmployeeNumber = (select reportsTo from Employees where employeeNumber = en);
 
 end
 delimiter
 
 -- 4
 CREATE TEMPORARY TABLE salary as
 select employee_id, salary
    from Employee_salary

select distinct * into salary2
from salary

select employee_id, salary, (count(salary)-1) as changes
from salary2
group by employee_id

-- 5
create temporary table e as
select employee_id, employee_name, gender, current_salary, department_id, start_date, term_date,  salary, year, month
from employee_salay
join employee using employee_id
where term_date > CURDATE() 


select d.department_id， e.employee_name as Employee, Salary 
    from Employee as e inner join Department as d
    on e.DepartmentId = d.Id
    inner join employee-salary as s using(employee_id)
    where (select count(distinct(e1.Salary)) from e as e1 where e1.Departmen_tId = e.Departmen_tId and e1.Salary > e.Salary) < 3
    order by e.Salary desc;

