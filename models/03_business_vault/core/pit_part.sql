select
    h.PART_HK            as part_hk,
    h.P_PARTKEY          as part_id,
    trim(s.P_NAME)       as part_name,
    trim(s.P_BRAND)      as brand,
    trim(s.P_TYPE)       as part_type,
    s.P_SIZE             as part_size,
    trim(s.P_CONTAINER)  as container,
    s.P_RETAILPRICE      as retail_price,
    s.LOAD_DATETIME      as load_datetime,
    s.RECORD_SOURCE      as record_source
from {{ ref('hub_part') }} h
inner join {{ ref('sat_part') }} s
    on h.PART_HK = s.PART_HK
qualify row_number() over (
    partition by h.PART_HK
    order by s.LOAD_DATETIME desc
) = 1
