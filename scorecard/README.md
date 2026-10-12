# scorecard

Fourth level of the chain: `customers` -> `products` / `revenue` -> `combined` -> `scorecard`.
It runs only when `combined` built in the last 7 minutes (`combined_max_age_minutes`) and fails with the
age of `combined` otherwise. It publishes one row of headline numbers plus whether the revenue cuts reconciled.

Register with project name `scorecard`.
