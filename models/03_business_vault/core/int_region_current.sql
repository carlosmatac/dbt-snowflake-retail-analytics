with latest as (
    select
        r.REGION_HK as region_hk,
        r.R_REGIONKEY as region_id,
        sr.R_NAME as region_name,
        sr.LOAD_DATETIME,
        row_number() over (
            partition by r.REGION_HK 
            order by sr.LOAD_DATETIME desc
        ) as rn
    from {{ ref('hub_region') }} r
    join {{ ref('sat_region') }} sr 
        on r.REGION_HK = sr.REGION_HK
)

select
    region_hk,
    region_id,
    region_name
from latest
where rn = 1