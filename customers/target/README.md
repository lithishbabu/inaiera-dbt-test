# target

dbt writes compiled SQL, `manifest.json` and `run_results.json` here during a run.
The dbt Runner uses a fresh clone per run and keeps the results itself, so this folder
is output only. This note only keeps the folder in the repository.
