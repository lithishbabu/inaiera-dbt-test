-- Monthly and per-city revenue are two cuts of the same orders: totals must agree.
select m.total as monthly_total, c.total as city_total
from (select sum(revenue) as total from {{ ref('monthly_revenue') }}) m
cross join (select sum(revenue) as total from {{ ref('city_revenue') }}) c
where m.total <> c.total
