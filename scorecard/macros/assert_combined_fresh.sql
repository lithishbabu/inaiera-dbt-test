-- Fails the run unless the upstream `combined` project built within max_age_minutes.
-- `combined` stamps public.revenue_reconciliation.built_at on every successful build, and that
-- table only exists once `combined` has run — so this also covers the "never built" case.
{% macro assert_combined_fresh(max_age_minutes) %}
  {% if execute %}
    {% set age = upstream_age_minutes('revenue_reconciliation') %}
    {% if age is none %}
      {{ exceptions.raise_compiler_error("Upstream project 'combined' has never been built. Run combined first.") }}
    {% elif age > (max_age_minutes | float) %}
      {{ exceptions.raise_compiler_error("Upstream project 'combined' last built " ~ (age | round(1)) ~ " min ago (limit " ~ max_age_minutes ~ " min). Run combined first.") }}
    {% endif %}
    {{ return(age) }}
  {% endif %}
  {{ return(0) }}
{% endmacro %}
