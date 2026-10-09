-- Passes only if BOTH products and revenue built within max_age_minutes;
-- fails when either one is stale or has never been built.
{% macro assert_all_upstream_fresh(max_age_minutes) %}
  {% if execute %}
    {% set limit = max_age_minutes | float %}
    {% set p = upstream_age_minutes('products_last_build') %}
    {% set r = upstream_age_minutes('revenue_last_build') %}
    {% set problems = [] %}
    {% if p is none %}
      {% do problems.append("products never built") %}
    {% elif p > limit %}
      {% do problems.append("products last built " ~ (p | round(1)) ~ " min ago") %}
    {% endif %}
    {% if r is none %}
      {% do problems.append("revenue never built") %}
    {% elif r > limit %}
      {% do problems.append("revenue last built " ~ (r | round(1)) ~ " min ago") %}
    {% endif %}
    {% if problems | length > 0 %}
      {{ exceptions.raise_compiler_error(
           "Both upstream projects must be up to date (limit " ~ max_age_minutes ~ " min), but: "
           ~ (problems | join("; ")) ~ ". Run products and revenue first.") }}
    {% endif %}
    {{ return({'products_age': p, 'revenue_age': r}) }}
  {% endif %}
  {{ return({'products_age': 0, 'revenue_age': 0}) }}
{% endmacro %}
