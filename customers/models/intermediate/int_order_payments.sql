-- One row per order that has at least one payment.
select
    order_id,
    count(*) as payment_count,
    sum(amount) as total_paid,
    string_agg(distinct payment_method, ', ' order by payment_method) as payment_methods
from {{ ref('stg_payments') }}
group by order_id
