select
    product_id,
    product_name,
    category,
    {{ cents_to_currency('unit_price_cents') }} as unit_price
from {{ ref('raw_products') }}
