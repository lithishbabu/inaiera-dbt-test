-- Category revenue shares should add up to ~100 (rounding allowed).
select sum(revenue_share_pct) as total_pct
from {{ ref('category_performance') }}
having abs(sum(revenue_share_pct) - 100) > 1
