-- Stock counts can never be below zero.
select * from {{ ref('inv_stock_status') }} where qty_on_hand < 0
