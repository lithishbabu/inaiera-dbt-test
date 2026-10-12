-- A SKU appears once per warehouse.
select sku, warehouse, count(*) as n
from {{ ref('inv_stock_status') }}
group by sku, warehouse
having count(*) > 1
