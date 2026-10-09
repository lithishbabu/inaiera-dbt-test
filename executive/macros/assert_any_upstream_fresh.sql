-- Passes if AT LEAST ONE of products / revenue built within max_age_minutes;
-- fails only when both are stale or have never been built.
{% macro assert_any_upstream_fresh(max_age_minutes) %}
  {% if execute %}
    {% set p = upstream_age_minutes('products_last_build') %}
    {% set r = upstream_age_minutes('revenue_last_build') %}
    {% set p_ok = p is not none and p <= (max_age_minutes | float) %}
    {% set r_ok = r is not none and r <= (max_age_minutes | float) %}
    {% if not (p_ok or r_ok) %}
      {{ exceptions.raise_compiler_error(
           "Neither upstream project is up to date (limit " ~ max_age_minutes ~ " min): products "
           ~ ("never built" if p is none else (p | round(1) ~ " min ago")) ~ ", revenue "
           ~ ("never built" if r is none else (r | round(1) ~ " min ago"))
           ~ ". Run products or revenue first.") }}
    {% endif %}
    {{ return({'products_age': p, 'revenue_age': r, 'products_fresh': p_ok, 'revenue_fresh': r_ok}) }}
  {% endif %}
  {{ return({'products_age': none, 'revenue_age': none, 'products_fresh': false, 'revenue_fresh': false}) }}
{% endmacro %}
