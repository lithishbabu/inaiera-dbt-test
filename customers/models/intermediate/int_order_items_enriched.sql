-- One row per order line, with product details and the line total.
select
    i.order_item_id,
    i.order_id,
    i.product_id,
    p.product_name,
    p.category,
    i.quantity,
    p.unit_price,
    i.quantity * p.unit_price as line_total
from {{ ref('stg_order_items') }} i
join {{ ref('stg_products') }} p using (product_id)
