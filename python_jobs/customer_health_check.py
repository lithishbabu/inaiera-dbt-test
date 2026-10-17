"""Python job for the Trino engine: data-health checks on the customers the dbt project built.

Reads pg_lake's public.dim_customers through Trino's read-only "postgresql" catalog, gives each check a status (ok / warn / fail),
appends the results to the Iceberg table iceberg.reports.customer_health_checks and prints them.
If any check FAILS the script exits with code 1, so the run is marked failed (and its Dependents with it).

Connection: the Runner hands the job its Trino in the environment (INAIERA_TRINO_HOST / _PORT / _CATALOG / _HTTP_SCHEME, and
INAIERA_TRINO_JWT, or INAIERA_TRINO_USER on a local Trino without authentication). Never write credentials in code.
Packages: requirements.txt in this folder.
"""
import os
import sys

import trino
from tabulate import tabulate

if os.environ.get("INAIERA_ENGINE") != "trino":
    sys.exit("This example runs on the Trino engine. Register the job with engine Trino.")

jwt = os.environ.get("INAIERA_TRINO_JWT")
conn = trino.dbapi.connect(
    host=os.environ["INAIERA_TRINO_HOST"],
    port=int(os.environ["INAIERA_TRINO_PORT"]),
    http_scheme=os.environ["INAIERA_TRINO_HTTP_SCHEME"],
    catalog=os.environ["INAIERA_TRINO_CATALOG"],
    user=os.environ.get("INAIERA_TRINO_USER", "inaiera-python-job"),
    auth=trino.auth.JWTAuthentication(jwt) if jwt else None,
)
cur = conn.cursor()


def run(sql):
    """Run one statement; Trino runs it as its result is read, so always read it."""
    cur.execute(sql)
    return cur.fetchall()


def scalar(sql):
    return run(sql)[0][0]


CUSTOMERS = "postgresql.public.dim_customers"
# (name, SQL returning one number, what makes it a warning, what makes it a failure)
CHECKS = [
    ("customers",                  f"select count(*) from {CUSTOMERS}",                                         None,             lambda n: n == 0),
    ("missing email",              f"select count(*) from {CUSTOMERS} where email is null or email = ''",       lambda n: n > 0, None),
    ("duplicate email",            f"select count(*) - count(distinct lower(email)) from {CUSTOMERS}",          None,             lambda n: n > 0),
    ("customers without purchase", f"select count(*) from {CUSTOMERS} where revenue_orders = 0",                lambda n: n > 0, None),
    ("negative lifetime value",    f"select count(*) from {CUSTOMERS} where lifetime_value < 0",                None,             lambda n: n > 0),
]

results = []
for name, sql, warn, fail in CHECKS:
    value = scalar(sql)
    status = "fail" if fail and fail(value) else "warn" if warn and warn(value) else "ok"
    results.append((name, value, status))

run("create schema if not exists iceberg.reports")
run("""create table if not exists iceberg.reports.customer_health_checks (
              checked_at timestamp(6) with time zone, run_id varchar, check_name varchar, value bigint, status varchar)""")
run_id = os.environ.get("INAIERA_RUN_ID", "").replace("'", "")
rows = ", ".join(f"(current_timestamp, '{run_id}', '{name}', {int(value)}, '{status}')" for name, value, status in results)
run(f"insert into iceberg.reports.customer_health_checks values {rows}")   # one insert = one Iceberg commit

print(tabulate(results, headers=["check", "value", "status"]))
failed = [name for name, _, status in results if status == "fail"]
warned = [name for name, _, status in results if status == "warn"]
print(f"{len(results)} checks: {len(failed)} failed, {len(warned)} warnings; written to iceberg.reports.customer_health_checks")
if failed:
    sys.exit(f"customer health check FAILED: {', '.join(failed)}")
