-- First step of this project: stops the run unless BOTH products and revenue are up to date.
{% set s = assert_all_upstream_fresh(var('upstream_max_age_minutes')) %}
select
    round({{ s['products_age'] }}::numeric, 1) as products_age_minutes,
    round({{ s['revenue_age'] }}::numeric, 1) as revenue_age_minutes,
    now() as checked_at
