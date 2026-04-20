{{ config(severity = 'warn') }}

with dim_count as (
    select count(*) as n from {{ ref('dim_customers') }}
),
hub_count as (
    select count(*) as n from {{ ref('hub_customer') }}
)
select
    d.n as dim_rows,
    h.n as hub_rows
from dim_count d, hub_count h
where d.n <> h.n
