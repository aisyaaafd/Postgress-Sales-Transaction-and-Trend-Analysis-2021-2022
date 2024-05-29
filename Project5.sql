select
extract(month from order_date) as month_2021,
round(sum(after_discount)) as total_sales
from order_detail
where
is_valid = 1
and order_date between '2021-01-01' and '2021-12-31'
group by month_2021
order by total_sales desc

select
sd.category,
round(sum(od.after_discount)) as total_sales
from order_detail as od
join sku_detail as sd
on od.sku_id = sd.id
where
is_valid = 1
and order_date between '2022-01-01' and '2022-12-31'
group by sd.category
order by total_sales desc

with a as (
select
sd.category,
round(sum(case when order_date between '2021-01-01' and '2021-12-31' then
od.after_discount end)) as total_sales_2021,
round(sum(case when order_date between '2022-01-01' and '2022-12-31' then
od.after_discount end)) as total_sales_2022
from order_detail as od
join sku_detail as sd
on sd.id = od.sku_id
where
is_valid = 1
group by sd.category
order by total_sales_2021 desc)
select
a.*,
total_sales_2022 - total_sales_2021 as growth_value
from a
order by growth_value desc

select
pd.payment_method,
count(distinct od.id) as total_pelanggan
from order_detail as od
join payment_detail as pd
on pd.id = od.payment_id
where
is_valid = 1
and order_date between '2022-01-01' and '2022-12-31'
group by pd.payment_method
order by total_pelanggan desc
limit 5

with a as (
select
case
when lower(sd.sku_name) like '%samsung%' then 'Samsung'
when lower(sd.sku_name) like '%iphone%' or lower (sd.sku_name) like '%ipad%'
or lower (sd.sku_name) like '%macbook%' or lower (sd.sku_name) like '%apple%' then
'Apple'
when lower(sd.sku_name) like '%sony%' then 'Sony'
when lower(sd.sku_name) like '%huawei%' then 'Huawei'
when lower(sd.sku_name) like '%lenovo%' then 'Lenovo'
end as product_name,
sum(od.after_discount) total_sales
from order_detail as od
join sku_detail as sd
on sd.id = od.sku_id
where
is_valid = 1
group by product_name
)
select * from a
where product_name is not null
order by total_sales desc