-- One row per SKU per warehouse, typed and renamed.
select
    sku,
    product_name,
    warehouse,
    qty_on_hand::int as qty_on_hand,
    reorder_level::int as reorder_level,
    supplier_id::int as supplier_id,
    last_counted::date as last_counted
from {{ ref('inv_stock_levels') }}
