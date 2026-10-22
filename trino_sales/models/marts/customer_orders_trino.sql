-- Orders per customer, joined across catalogs: dim_customers lives in pg_lake (Postgres) and is read by Trino
-- through the "postgresql" catalog in the same query as the Iceberg tables this project builds.
select
    c.customer_id,
    c.full_name,
    c.city,
    c.customer_segment,
    count(o.order_id)                                             as orders,
    coalesce(cast(sum(case when o.is_revenue then o.order_total end) as decimal(14, 2)), 0) as revenue
from {{ source('warehouse', 'dim_customers') }} c
left join {{ ref('fct_trino_orders') }} o on o.customer_id = c.customer_id
group by c.customer_id, c.full_name, c.city, c.customer_segment
