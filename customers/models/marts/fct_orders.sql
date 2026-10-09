-- One row per order with totals, payment status and a revenue flag.
with orders as (
    select * from {{ ref('stg_orders') }}
),
items as (
    select
        order_id,
        count(*) as line_count,
        sum(quantity) as units,
        sum(line_total) as order_total
    from {{ ref('int_order_items_enriched') }}
    group by order_id
),
payments as (
    select * from {{ ref('int_order_payments') }}
)
select
    o.order_id,
    o.customer_id,
    o.order_date,
    o.status,
    coalesce(i.line_count, 0) as line_count,
    coalesce(i.units, 0) as units,
    coalesce(i.order_total, 0) as order_total,
    coalesce(p.total_paid, 0) as total_paid,
    p.payment_methods,
    {{ is_revenue_status('o.status') }} as is_revenue,
    case
        when coalesce(p.total_paid, 0) = 0 then 'unpaid'
        when p.total_paid < coalesce(i.order_total, 0) then 'partial'
        else 'paid'
    end as payment_status
from orders o
left join items i using (order_id)
left join payments p using (order_id)
