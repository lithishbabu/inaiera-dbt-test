{#- Convert an integer amount in cents to a 2-decimal currency amount. -#}
{% macro cents_to_currency(column_name, precision=2) %}
    round({{ column_name }}::numeric / 100, {{ precision }})
{% endmacro %}
