-- SQL job: rebuilds a small report from the tables the dbt projects already built (dim_customers).
-- The statements run one after another. On pg_lake (or a Postgres connection) they run in ONE transaction:
-- if any statement fails, nothing is kept. Comments like these are ignored.

create schema if not exists reports;

drop table if exists reports.customer_segment_summary;

create table reports.customer_segment_summary as
select
    customer_segment,
    count(*)                              as customers,
    coalesce(sum(lifetime_value), 0)      as total_lifetime_value,
    round(avg(lifetime_value), 2)         as avg_lifetime_value,
    now()                                 as refreshed_at
from public.dim_customers
group by customer_segment;

-- The last statement's row count shows in the run's steps.
select * from reports.customer_segment_summary order by total_lifetime_value desc;
