-- SQL job for the Trino engine: adds ONE row per run to iceberg.reports.revenue_snapshots (it never deletes), so on a schedule it
-- builds a history of how customers, orders and revenue grow over time.
-- It reads the tables the dbt projects built in pg_lake through Trino's read-only "postgresql" catalog, and writes an Iceberg table.
-- Trino has no transaction across statements: they run in order and the first error stops the job.

create schema if not exists iceberg.reports;

create table if not exists iceberg.reports.revenue_snapshots (
    snapshot_at      timestamp(6) with time zone,
    customers        bigint,
    revenue_orders   bigint,
    revenue          decimal(18, 2),
    avg_order_value  decimal(18, 2)
);

insert into iceberg.reports.revenue_snapshots
select
    current_timestamp,
    (select count(*) from postgresql.public.dim_customers),
    count(*),
    coalesce(cast(sum(order_total) as decimal(18, 2)), 0),
    coalesce(cast(round(avg(order_total), 2) as decimal(18, 2)), 0)
from postgresql.public.fct_orders
where is_revenue;

-- The latest five snapshots (newest first).
select * from iceberg.reports.revenue_snapshots order by snapshot_at desc limit 5;
