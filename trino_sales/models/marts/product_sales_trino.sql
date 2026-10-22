-- Units and revenue per product, ranked inside its category (window function).
with sold as (
    select
        p.product_id,
        p.product_name,
        p.category,
        sum(i.quantity)                                           as units_sold,
        cast(sum(i.line_total) as decimal(14, 2))                 as revenue
    from {{ ref('stg_trino_order_items') }} i
    join {{ ref('stg_trino_orders') }} o on o.order_id = i.order_id and o.status in ('completed', 'shipped')
    join {{ ref('stg_trino_products') }} p on p.product_id = i.product_id
    group by p.product_id, p.product_name, p.category
)
select
    *,
    rank() over (partition by category order by revenue desc)     as rank_in_category
from sold
