-- products and revenue are two cuts of the same revenue orders, so their grand totals
-- must agree. That comparison is only meaningful when BOTH are current, which is why
-- this project refuses to run otherwise.
select
    r.total_revenue as revenue_project_total,
    p.total_revenue as products_project_total,
    r.total_revenue - p.total_revenue as difference,
    r.total_revenue = p.total_revenue as totals_match,
    c.products_age_minutes,
    c.revenue_age_minutes,
    now() as built_at
from {{ ref('combined_upstream_check') }} c
cross join (select sum(revenue) as total_revenue from public.monthly_revenue) r
cross join (select sum(revenue) as total_revenue from public.product_performance) p
