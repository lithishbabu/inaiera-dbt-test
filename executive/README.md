# executive

Summary project that depends on `products` OR `revenue`: it runs as long as at least one of
them built in the last 7 minutes (`upstream_max_age_minutes`), and fails only when both are stale.
The summary shows data only from the sources that are fresh.

Register with project name `executive`.
