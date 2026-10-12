-- Minutes since a project last finished building, from its *_last_build stamp table.
-- Returns none when the stamp table does not exist yet (project never built).
{% macro upstream_age_minutes(stamp_table) %}
  {% set exists = run_query("select to_regclass('public." ~ stamp_table ~ "') is not null").columns[0].values()[0] %}
  {% if not exists %}
    {{ return(none) }}
  {% endif %}
  {% set age = run_query("select extract(epoch from (now() - max(built_at))) / 60.0 from public." ~ stamp_table).columns[0].values()[0] %}
  {{ return(none if age is none else (age | float)) }}
{% endmacro %}
