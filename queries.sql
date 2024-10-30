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

--Задача 6, пункт 1
--Мне кажется тут есть второй способ решения, тк в задаче указано про сортировку. 
--Но это решение для меня кажется легким.
--Решаю с помощью union all
select 
--Первая колонка это возрастной диапазон
'16-25' as age_category,
--Вторая – счет, выбираю *, тк могут быть совпадающие по некоторым столбцам данные
count(*) as age_count
from customers c 
--Условие для выборки по возрасту
where age between '16' and '25'
--Соединияю все значения (тут кажется может и просто union подойти, тк значения не одинаковые)
union all 
--Повторяю для двух других возрастных групп, меняя условия
select 
'26-40' as age_category,
count(*) as age_count
from customers c 
where age between '26' and '40'
union all 
select 
'40+' as age_category,
count(*) as age_count
from customers c 
where age > 40;


--Задача 6, пункт 2
select
--Привожу дату к нужному виду
to_char(sale_date, 'YYYY-MM') as selling_month,
--Подсчет покупателей по всем строкам таблицы
count(*) as total_customers,
sum(quantity) as income
from sales
--Группировка по дате
group by to_char(sale_date, 'YYYY-MM')
--Сортировка по возрастанию даты
order by selling_month;

--Задача 6, пункт 3
select 
concat(c.first_name, ' ', c.last_name) as customer,
s.sale_date as sale_date,
concat(e.first_name, ' ', e.last_name) as seller
from sales s 
--Присоединяю все таблицы
inner join employees e 
on e.employee_id = s.sales_person_id
inner join customers c 
on c.customer_id = s.customer_id
inner join products p 
on p.product_id = s.product_id
--Условие выборки и сортировки
where p.price = 0
order by c.customer_id;




