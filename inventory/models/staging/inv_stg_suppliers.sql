select
    supplier_id::int as supplier_id,
    supplier_name,
    city,
    lead_time_days::int as lead_time_days
from {{ ref('inv_suppliers') }}
