-- One row per product: how much it sold, how often, and when it last sold.
select
    product_id,
    product_name,
    category,
    count(distinct order_id) as orders,
    sum(quantity) as units_sold,
    sum(line_total) as revenue,
    max(order_date) as last_sold_on
from {{ ref('product_order_lines') }}
group by product_id, product_name, category
