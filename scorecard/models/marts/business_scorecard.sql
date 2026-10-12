-- One row: the headline numbers of the whole pipeline, and whether the two independent
-- cuts of revenue (products vs revenue project) reconciled in the last `combined` run.
select
    r.revenue_project_total  as total_revenue,
    (select sum(orders) from public.monthly_revenue) as total_orders,
    round(r.revenue_project_total / nullif((select sum(orders) from public.monthly_revenue), 0), 2) as avg_order_value,
    (select city from public.city_revenue order by revenue desc limit 1) as top_city,
    (select product_name from public.product_performance order by revenue desc limit 1) as top_product,
    r.totals_match as reconciled,
    c.combined_age_minutes,
    now() as built_at
from {{ ref('scorecard_upstream_check') }} c
cross join (select * from public.revenue_reconciliation order by built_at desc limit 1) r
