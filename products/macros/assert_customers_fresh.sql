-- Fails the run when the upstream `customers` project has not built recently.
-- `customers` stamps public.meta_last_build on every build; if that stamp is older
-- than max_age_minutes the data this project reads is stale, so we stop here.
{% macro assert_customers_fresh(max_age_minutes) %}
  {% if execute %}
    {% set res = run_query("select extract(epoch from (now() - max(built_at))) / 60.0 from public.meta_last_build") %}
    {% set age = res.columns[0].values()[0] %}
    {% if age is none %}
      {{ exceptions.raise_compiler_error("Upstream project 'customers' has never been built.") }}
    {% elif (age | float) > (max_age_minutes | float) %}
      {{ exceptions.raise_compiler_error("Upstream project 'customers' last built " ~ (age | float | round(1)) ~ " min ago (limit " ~ max_age_minutes ~ " min). Run customers first.") }}
    {% endif %}
    {{ return(age | float) }}
  {% endif %}
  {{ return(0) }}
{% endmacro %}
