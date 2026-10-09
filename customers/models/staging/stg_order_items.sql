select
    order_item_id,
    order_id,
    product_id,
    quantity
from {{ ref('raw_order_items') }}
