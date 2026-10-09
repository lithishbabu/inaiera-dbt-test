-- One row per city: how many customers ordered, how many orders, and the revenue.
select
    coalesce(city, 'unknown') as city,
    count(distinct customer_id) as customers,
    count(*) as orders,
    sum(order_total) as revenue
from {{ ref('revenue_orders') }}
group by coalesce(city, 'unknown')
