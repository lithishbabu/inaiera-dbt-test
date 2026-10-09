# customers (dbt demo project)

A small online-store project for the InAiEra dbt Runner, built entirely from CSV seeds.

| Layer | Folder | What is in it |
|---|---|---|
| Seeds | `seeds/` | `raw_customers`, `raw_products`, `raw_orders`, `raw_order_items`, `raw_payments` |
| Staging | `models/staging/` | Clean, renamed copies of each seed (views) |
| Intermediate | `models/intermediate/` | Order lines with product details; payments per order (views) |
| Marts | `models/marts/` | `fct_orders`, `dim_customers`, `fct_daily_revenue` (tables) |
| Macros | `macros/` | `cents_to_currency`, `is_revenue_status`, and a `positive_value` test |
| Snapshots | `snapshots/` | `customers_snapshot` keeps history of email / city changes |
| Tests | `tests/` | Two singular tests plus the column tests in the `.yml` files |

Run it with the dbt Runner, engine `pg_lake` (Jobs -> dbt -> Run now).
