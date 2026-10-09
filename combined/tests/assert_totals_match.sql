-- The two projects must report the same grand total.
select * from {{ ref('revenue_reconciliation') }} where not totals_match
