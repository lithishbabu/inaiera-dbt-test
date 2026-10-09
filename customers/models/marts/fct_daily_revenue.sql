-- Revenue per day, counting only revenue statuses after var revenue_start_date.
select
    order_date,
    count(*) as orders_count,
    sum(order_total) as revenue,
    round(avg(order_total), 2) as avg_order_value
from {{ ref('fct_orders') }}
where is_revenue
  and order_date >= '{{ var("revenue_start_date") }}'::date
group by order_date
