-- Fails (returns rows) if any order or day has a negative total.
select order_id as id, order_total as total from {{ ref('fct_trino_orders') }} where order_total < 0
union all
select cast(null as bigint), revenue from {{ ref('daily_sales_trino') }} where revenue < 0
