install.packages("RMySQL")
library(RMySQL)
library(ggplot2)
mydb = dbConnect(MySQL(), user='root', password='ycy19941022', dbname='ClassicModels', host='localhost')
dbListTables(mydb)

#Visualize in blue the number of items for each product scale.
p_scale = dbSendQuery(mydb, 
                      "select productScale,count(*) as quantity
                      from Products
                      group by productScale")
scale1 = fetch(p_scale, n=-1)
scale1
ggplot(data=scale1, aes(x=productScale, y=quantity)) +
  geom_bar(stat = "identity",fill=c("blue"))

#Prepare a line plot with appropriate labels for total payments for each month in 2004.
pay_m = dbSendQuery(mydb, 
                      "select month(paymentDate) as month, sum(amount) as totalpay
from Payments
where year(paymentDate) = 2004
group by month
order by month")
pay1 = fetch(pay_m, n=-1)
pay1
payplot <- ggplot(data=pay1, mapping = aes(x=month, y=totalpay)) +
  geom_line (stat = "identity")+
  geom_point()
payplot + xlim(0,13)

#Create a histogram with appropriate labels for the value of orders received from the Nordic countries (Denmark,Finland, Norway,Sweden).
c_orderv = dbSendQuery(mydb, 
"select c.country, sum(r.quantityOrdered*r.priceEach) as value
from Customers as c
left join Orders as o 
on c.customerNumber = o.customerNumber
left join OrderDetails as r 
on r.orderNumber = o.orderNumber
where c.country in ('Denmark', 'Finland', 'Norway','Sweden')
group by c.country")

order1 = fetch(c_orderv, n=-1)
order1

ggplot(data=order1, aes(x=country, y=value)) +
  geom_histogram (stat = "identity")

#Create a heatmap for product lines and Norwegian cities.
pl_n = dbSendQuery(mydb, 
                    "select p.productLine,  c.city
from Products as p
                   inner join OrderDetails   as r using ( productCode)
                   inner join Orders as o using (orderNumber)
                   inner join Customers  as c using (customerNumber)
                   where country = 'Norway'
                   order by p.productLine")
plN = fetch(pl_n, n=-1)
plN
plN2<-as.data.frame(table(plN)) 
heatmap <- ggplot(data=plN2, aes(x=productLine, y=city,fill=Freq)) +
  geom_tile()

#Create a parallel coordinates plot for product scale, quantity in stock, and MSRP in the Products table.
library(GGally)
data = dbSendQuery(mydb, 
                   "select productScale,quantityInStock,MSRP,productLine
                   from Products ")
data1 = fetch(data, n=-1)
data1
pc <- ggparcoord(data = data1, columns = c(1,2,3),groupColumn = 4)
pc
