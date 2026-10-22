select
    order_item_id,
    order_id,
    product_id,
    quantity,
    cast(unit_price as decimal(12, 2))                          as unit_price,
    cast(quantity * unit_price as decimal(14, 2))               as line_total
from {{ ref('trino_order_items') }}
