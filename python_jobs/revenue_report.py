"""Python job: builds reports.monthly_revenue_python from the dbt table fct_orders and prints a summary.

How a job gets its database: the Runner puts the warehouse into the environment of the run. On the pg_lake engine that is
INAIERA_DATABASE_URL (or PGHOST / PGUSER / PGPASSWORD / PGDATABASE). Never write a password in the code.
Packages come from requirements.txt in this folder, installed fresh for every run. The Runner uses Python 3.11.
"""
import os
import sys

import psycopg2
from tabulate import tabulate

engine = os.environ.get("INAIERA_ENGINE", "")
if engine != "pg_lake":
    sys.exit(f"This example runs on the pg_lake engine (this run uses '{engine}'). Register the job with engine pg_lake.")

print(f"run {os.environ.get('INAIERA_RUN_ID', '')[:8]} on commit {os.environ.get('INAIERA_GIT_SHA', '')[:8]}")

conn = psycopg2.connect(os.environ["INAIERA_DATABASE_URL"])
try:
    with conn, conn.cursor() as cur:          # "with conn" commits at the end, or rolls back if anything fails
        cur.execute("create schema if not exists reports")
        cur.execute("drop table if exists reports.monthly_revenue_python")
        cur.execute("""
            create table reports.monthly_revenue_python as
            select date_trunc('month', order_date)::date as order_month,
                   count(*)                              as orders,
                   sum(order_total)                      as revenue,
                   sum(total_paid)                       as collected,
                   now()                                 as refreshed_at
            from public.fct_orders
            where is_revenue
            group by 1
        """)
        cur.execute("select order_month, orders, revenue, collected from reports.monthly_revenue_python order by order_month")
        rows = cur.fetchall()
finally:
    conn.close()

print(tabulate(rows, headers=["month", "orders", "revenue", "collected"]))
print(f"wrote {len(rows)} rows to reports.monthly_revenue_python")
