-- One row per order with its totals. Revenue only counts completed and shipped orders.
select
    o.order_id,
    o.customer_id,
    o.order_date,
    o.status,
    count(i.order_item_id)                                       as line_count,
    sum(i.quantity)                                              as units,
    cast(sum(i.line_total) as decimal(14, 2))                    as order_total,
    o.status in ('completed', 'shipped')                         as is_revenue,
    array_join(array_agg(distinct p.category order by p.category), ', ') as categories   -- Trino array functions
from {{ ref('stg_trino_orders') }} o
join {{ ref('stg_trino_order_items') }} i on i.order_id = o.order_id
join {{ ref('stg_trino_products') }} p on p.product_id = i.product_id
group by o.order_id, o.customer_id, o.order_date, o.status
