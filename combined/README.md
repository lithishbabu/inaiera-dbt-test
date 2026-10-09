# combined

Reconciliation project that depends on `products` AND `revenue`: it runs only when both built in
the last 7 minutes (`upstream_max_age_minutes`) and fails if either one is stale or never built.
It compares the grand revenue total from both projects; a test fails if they disagree.

Register with project name `combined`.
