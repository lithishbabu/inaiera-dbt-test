{#- True when an order status counts toward revenue (driven by var non_revenue_statuses). -#}
{% macro is_revenue_status(column_name) %}
    ({{ column_name }} not in (
        {%- for s in var('non_revenue_statuses') -%}
            '{{ s }}'{{ ", " if not loop.last }}
        {%- endfor -%}
    ))
{% endmacro %}
