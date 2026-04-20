select
    h.NATION_HK       as nation_hk,
    h.N_NATIONKEY     as nation_id,
    s.N_NAME          as nation_name,
    ln.REGION_HK      as region_hk,
    s.LOAD_DATETIME   as load_datetime,
    s.RECORD_SOURCE   as record_source
from {{ ref('hub_nation') }} h
inner join {{ ref('sat_nation') }} s
    on h.NATION_HK = s.NATION_HK
left join {{ ref('link_nation_region') }} ln
    on h.NATION_HK = ln.NATION_HK
qualify row_number() over (
    partition by h.NATION_HK
    order by s.LOAD_DATETIME desc
) = 1
