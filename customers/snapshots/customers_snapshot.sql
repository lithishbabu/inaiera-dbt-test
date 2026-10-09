{% snapshot customers_snapshot %}

{{
    config(
        target_schema='snapshots',
        unique_key='customer_id',
        strategy='check',
        check_cols=['email', 'city']
    )
}}

-- Keeps history whenever a customer's email or city changes.
select * from {{ ref('stg_customers') }}

{% endsnapshot %}
