{{ config(materialized='table') }}
-- One row, rewritten at the end of every successful build of this project.
-- Downstream projects read built_at to check that revenue is up to date.
select
    now() as built_at,
    (select count(*) from {{ ref('monthly_revenue') }}) as months_seen,
    (select count(*) from {{ ref('city_revenue') }}) as cities_seen
