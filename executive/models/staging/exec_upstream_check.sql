-- First step of this project: stops the run unless products OR revenue is up to date,
-- and records which of them were fresh for the models that follow.
{% set s = assert_any_upstream_fresh(var('upstream_max_age_minutes')) %}
select
    {{ s['products_fresh'] }}::boolean as products_fresh,
    {{ s['revenue_fresh'] }}::boolean as revenue_fresh,
    {{ 'null' if s['products_age'] is none else (s['products_age'] | round(1)) }}::numeric as products_age_minutes,
    {{ 'null' if s['revenue_age'] is none else (s['revenue_age'] | round(1)) }}::numeric as revenue_age_minutes,
    now() as checked_at
