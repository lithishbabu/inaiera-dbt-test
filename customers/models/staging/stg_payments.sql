select
    payment_id,
    order_id,
    payment_method,
    {{ cents_to_currency('amount_cents') }} as amount
from {{ ref('raw_payments') }}
