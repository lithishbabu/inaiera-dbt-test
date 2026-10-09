-- One row per customer with lifetime value and a simple segment.
with customers as (
    select * from {{ ref('stg_customers') }}
),
revenue_orders as (
    select * from {{ ref('fct_orders') }} where is_revenue
),
agg as (
    select
        customer_id,
        count(*) as revenue_orders,
        min(order_date) as first_order_date,
        max(order_date) as last_order_date,
        sum(order_total) as lifetime_value
    from revenue_orders
    group by customer_id
)
select
    c.customer_id,
    c.full_name,
    c.email,
    c.city,
    c.signup_date,
    coalesce(a.revenue_orders, 0) as revenue_orders,
    a.first_order_date,
    a.last_order_date,
    coalesce(a.lifetime_value, 0) as lifetime_value,
    case
        when coalesce(a.lifetime_value, 0) >= 50000 then 'high'
        when coalesce(a.lifetime_value, 0) >= 15000 then 'medium'
        when coalesce(a.lifetime_value, 0) > 0 then 'low'
        else 'no_purchases'
    end as customer_segment
from customers c
left join agg a using (customer_id)
