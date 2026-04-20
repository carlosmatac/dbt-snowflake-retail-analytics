{{ config(materialized='table') }}

-- Snapshot date table consumed by automate_dv.pit().
-- Single-row "current" snapshot. For historical PITs, replace by
-- a spine (e.g., dbt_utils.date_spine) and re-materialize the pit_* as incremental.
select cast(current_timestamp as timestamp) as AS_OF_DATE
