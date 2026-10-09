-- One row per category, with each category's share of total revenue.
select
    category,
    count(distinct product_id) as products_sold,
    sum(units_sold) as units_sold,
    sum(revenue) as revenue,
    round(100.0 * sum(revenue) / nullif(sum(sum(revenue)) over (), 0), 1) as revenue_share_pct
from {{ ref('product_performance') }}
group by category
