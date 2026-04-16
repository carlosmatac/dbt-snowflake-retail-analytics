-- Intermediate model: Location current state (Business Vault)
-- Joins nation and region reference data

with nation as (
    select
        n.NATION_HK as nation_hk,
        n.N_NATIONKEY as nation_id,
        s.N_NAME as nation_name,
        s.N_REGIONKEY as region_id,
        s.LOAD_DATETIME as nation_load_datetime
    from {{ ref('hub_nation') }} n
    join {{ ref('sat_nation') }} s on n.NATION_HK = s.NATION_HK
),
region as (
    select
        r.REGION_HK as region_hk,
        r.R_REGIONKEY as region_id,
        s.R_NAME as region_name,
        s.LOAD_DATETIME as region_load_datetime
    from {{ ref('hub_region') }} r
    join {{ ref('sat_region') }} s on r.REGION_HK = s.REGION_HK
)
select
    n.nation_hk,
    n.nation_id,
    n.nation_name,
    rg.region_hk,
    rg.region_id,
    rg.region_name,
    n.nation_load_datetime,
    rg.region_load_datetime
from nation n
left join region rg on n.region_id = rg.region_id
