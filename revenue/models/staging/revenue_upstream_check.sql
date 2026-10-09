{{ config(materialized='table') }}
-- First step of this project: stops the whole run if `customers` is stale.
{% set age = assert_customers_fresh(var('customers_max_age_minutes')) %}
select round({{ age }}::numeric, 1) as customers_age_minutes, now() as checked_at
