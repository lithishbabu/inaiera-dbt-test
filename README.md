# inaiera-dbt-test

Two dbt projects in one repo. Register each one separately with its folder:

| Project | Git URL to register |
|---|---|
| `customers` (seeds → staging → marts) | `https://github.com/lithishbabu/inaiera-dbt-test.git#subdirectory=customers` |
| `products` (reads what `customers` built — run `customers` first) | `https://github.com/lithishbabu/inaiera-dbt-test.git#subdirectory=products` |

Branch `main`, engine `pg_lake`.
