-- First step of this project: stops the run unless `combined` (and so products and revenue) is up to date.
{% set age = assert_combined_fresh(var('combined_max_age_minutes')) %}
select round({{ age }}::numeric, 1) as combined_age_minutes, now() as checked_at
