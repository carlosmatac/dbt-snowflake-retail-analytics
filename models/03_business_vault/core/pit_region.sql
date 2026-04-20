select
    h.REGION_HK      as region_hk,
    h.R_REGIONKEY    as region_id,
    s.R_NAME         as region_name,
    s.LOAD_DATETIME  as load_datetime,
    s.RECORD_SOURCE  as record_source
from {{ ref('hub_region') }} h
inner join {{ ref('sat_region') }} s
    on h.REGION_HK = s.REGION_HK
qualify row_number() over (
    partition by h.REGION_HK
    order by s.LOAD_DATETIME desc
) = 1
