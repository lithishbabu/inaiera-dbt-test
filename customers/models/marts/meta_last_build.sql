-- One row, rewritten on every build of this project: when did it last finish building,
-- and how much data did it see? Downstream projects read this to check freshness.
select
    now() as built_at,
    (select count(*) from {{ ref('fct_orders') }}) as orders_seen,
    (select count(*) from {{ ref('dim_customers') }}) as customers_seen
