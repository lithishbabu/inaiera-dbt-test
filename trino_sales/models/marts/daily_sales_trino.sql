-- Revenue per week and per day. date_trunc and date_format are Trino functions.
select
    order_date,
    cast(date_trunc('week', order_date) as date)                  as week_start,
    date_format(order_date, '%Y-%m')                              as month,
    count(*)                                                      as orders,
    cast(sum(order_total) as decimal(14, 2))                      as revenue
from {{ ref('fct_trino_orders') }}
where is_revenue
group by order_date
