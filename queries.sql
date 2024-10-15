--Задача 4
select count(customer_id) as customers_count
from customers;
--Запрос считает количество значений в столбце customer_id из таблицы customers. Значение сохраняется с названием customers_count.


--Задача 5, пункт 1
select 
--Обозначаю столбцы используя функции
concat(e.first_name, ' ', e.last_name) as seller,
count(s.sales_id) as operations,
floor(sum(p.price * s.quantity)) as income
--За основу беру таблицу sales
from sales s 
--Присоединяю еще две таблицы с данными и назначаю псевдонимы для таблиц
inner join employees e 
on e.employee_id = s.sales_person_id
inner join products p 
on p.product_id = s.product_id 
--Группировка по продавцу, сортировка и лимит 10
group by seller
order by income desc
limit 10;



--Задача 5, пункт 2
select 
concat(e.first_name, ' ', e.last_name) as seller,
--Расчет средней выручки на каждого продавца
floor(avg(p.price * s.quantity)) as average_income
from sales s
inner join employees e 
on e.employee_id = s.sales_person_id
inner join products p 
on p.product_id = s.product_id
group by seller 
--Фильтрация по общей средней выручке
having floor(avg(p.price * s.quantity)) < (
select floor(avg(p.price * s.quantity))
from sales s
inner join products p 
on p.product_id = s.product_id)
order by average_income;


--Задача 5, пункт 3
select 
concat(e.first_name, ' ', e.last_name) as seller,
--Достаю название дня недели
to_char(s.sale_date, 'day') as day_of_week,
floor(sum(p.price * s.quantity)) as income
from sales s
inner join employees e 
on e.employee_id = s.sales_person_id
inner join products p 
on p.product_id = s.product_id
--Группировка по селлеру, по числу дня недели и по названию дня недели
group by seller, extract(isodow from sale_date), to_char(s.sale_date, 'day')
--Сортировка по числу дня недели и селлеру
order by extract(isodow from sale_date), seller;




