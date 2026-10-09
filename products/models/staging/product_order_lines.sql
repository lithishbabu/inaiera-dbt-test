-- Order lines that count as revenue, tagged with the date of their order.
select
    l.order_item_id,
    l.order_id,
    o.order_date,
    l.product_id,
    l.product_name,
    l.category,
    l.quantity,
    l.line_total
from {{ source('customers_project', 'int_order_items_enriched') }} l
join {{ source('customers_project', 'fct_orders') }} o using (order_id)
where o.is_revenue
