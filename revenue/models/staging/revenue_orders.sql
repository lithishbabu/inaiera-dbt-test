-- Orders that count as revenue, with the customer's city attached.
select
    o.order_id,
    o.customer_id,
    c.city,
    o.order_date,
    date_trunc('month', o.order_date)::date as order_month,
    o.order_total,
    o.total_paid
from {{ source('customers_project', 'fct_orders') }} o
left join {{ source('customers_project', 'dim_customers') }} c using (customer_id)
where o.is_revenue
