-- One row: headline numbers from whichever upstream projects are up to date.
-- A fresh source fills its columns; a stale one leaves them empty rather than
-- showing old numbers as if they were current.
select
    case when c.revenue_fresh then (select sum(revenue) from public.monthly_revenue) end as total_revenue,
    case when c.revenue_fresh then (select sum(orders) from public.monthly_revenue) end as total_orders,
    case when c.products_fresh then (select product_name from public.product_performance order by revenue desc limit 1) end as top_product,
    case when c.products_fresh then (select category from public.category_performance order by revenue desc limit 1) end as top_category,
    case
        when c.products_fresh and c.revenue_fresh then 'products + revenue'
        when c.revenue_fresh then 'revenue only'
        else 'products only'
    end as data_from,
    now() as built_at
from {{ ref('exec_upstream_check') }} c
