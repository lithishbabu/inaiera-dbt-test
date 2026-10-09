-- Fails for any revenue order whose payments do not add up to the order total.
select order_id, order_total, total_paid
from {{ ref('fct_orders') }}
where is_revenue
  and abs(order_total - total_paid) > 0.01
