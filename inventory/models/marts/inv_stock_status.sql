-- Per SKU and warehouse: how much is left, and whether it is time to reorder.
select
    s.sku,
    s.product_name,
    s.warehouse,
    s.qty_on_hand,
    s.reorder_level,
    greatest(s.reorder_level - s.qty_on_hand, 0) as units_below_reorder,
    case
        when s.qty_on_hand = 0 then 'out_of_stock'
        when s.qty_on_hand <= s.reorder_level then 'reorder'
        else 'ok'
    end as stock_status,
    sup.supplier_name,
    sup.lead_time_days,
    s.last_counted
from {{ ref('inv_stg_stock_levels') }} s
left join {{ ref('inv_stg_suppliers') }} sup using (supplier_id)
