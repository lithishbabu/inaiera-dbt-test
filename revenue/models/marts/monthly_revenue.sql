-- One row per month: orders, revenue, average order value and how much was actually paid.
select
    order_month,
    count(*) as orders,
    sum(order_total) as revenue,
    round(avg(order_total), 2) as avg_order_value,
    sum(total_paid) as collected,
    sum(order_total) - sum(total_paid) as outstanding
from {{ ref('revenue_orders') }}
group by order_month
