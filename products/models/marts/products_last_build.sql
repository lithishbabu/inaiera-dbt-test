{{ config(materialized='table') }}
-- One row, rewritten at the end of every successful build of this project.
-- Downstream projects read built_at to check that products is up to date.
select
    now() as built_at,
    (select count(*) from {{ ref('product_performance') }}) as products_seen,
    (select count(*) from {{ ref('category_performance') }}) as categories_seen
