-- SQL job: counts orders and their value per status (completed, shipped, cancelled ...) from fct_orders, built by the dbt project.

create schema if not exists reports;

drop table if exists reports.order_status_summary;

create table reports.order_status_summary as
select
    status,
    count(*)                         as orders,
    sum(order_total)                 as order_total,
    sum(total_paid)                  as total_paid,
    now()                            as refreshed_at
from public.fct_orders
group by status;

select * from reports.order_status_summary order by order_total desc;
