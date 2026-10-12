-- The scorecard is only trustworthy when the two revenue cuts agreed.
select * from {{ ref('business_scorecard') }} where not reconciled
