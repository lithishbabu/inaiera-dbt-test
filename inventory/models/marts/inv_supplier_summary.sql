-- Per supplier: how much of their stock we hold and how much needs reordering.
select
    sup.supplier_id,
    sup.supplier_name,
    sup.city,
    sup.lead_time_days,
    count(*) as skus,
    sum(st.qty_on_hand) as units_on_hand,
    count(*) filter (where st.stock_status <> 'ok') as skus_to_reorder
from {{ ref('inv_stg_suppliers') }} sup
join {{ ref('inv_stock_status') }} st using (supplier_name)
group by sup.supplier_id, sup.supplier_name, sup.city, sup.lead_time_days
