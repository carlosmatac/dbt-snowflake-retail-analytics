select
    h.REGION_HK      as region_hk,
    h.R_REGIONKEY    as region_id,
    s.R_NAME         as region_name,
    s.LOAD_DATETIME  as load_datetime,
    s.RECORD_SOURCE  as record_source
from {{ ref('hub_region') }} h
inner join {{ ref('pit_region') }} p
    on h.REGION_HK = p.REGION_HK
inner join {{ ref('sat_region') }} s
    on p.SAT_REGION_PK   = s.REGION_HK
   and p.SAT_REGION_LDTS = s.LOAD_DATETIME
