with latest as (
    select
        n.NATION_HK as nation_hk,
        n.N_NATIONKEY as nation_id,
        sn.N_NAME as nation_name,
        ln.REGION_HK as region_hk,
        sn.LOAD_DATETIME,
        row_number() over (
            partition by n.NATION_HK 
            order by sn.LOAD_DATETIME desc
        ) as rn
    from {{ ref('hub_nation') }} n
    join {{ ref('sat_nation') }} sn 
        on n.NATION_HK = sn.NATION_HK
    join {{ ref('link_nation_region') }} ln 
        on n.NATION_HK = ln.NATION_HK
)

select
    nation_hk,
    nation_id,
    nation_name,
    region_hk
from latest
where rn = 1