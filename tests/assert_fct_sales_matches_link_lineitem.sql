{{ config(severity = 'warn') }}

with fct_count as (
    select count(*) as n from {{ ref('fct_sales') }}
),
link_count as (
    select count(*) as n from {{ ref('link_lineitem') }}
)
select
    f.n as fct_rows,
    l.n as link_rows
from fct_count f, link_count l
where f.n <> l.n
