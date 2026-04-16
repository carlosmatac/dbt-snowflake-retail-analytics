-- Intermediate model: Part current state (Business Vault)
-- Flattens hub_part + latest sat_part

with part_latest as (
    select
        p.PART_HK as part_hk,
        p.P_PARTKEY as part_id,
        s.P_NAME as part_name,
        s.P_BRAND as brand,
        s.P_TYPE as type,
        s.P_SIZE as size,
        s.P_CONTAINER as container,
        s.P_RETAILPRICE as retail_price,
        s.LOAD_DATETIME as load_datetime,
        s.RECORD_SOURCE as record_source,
        row_number() over (partition by p.PART_HK order by s.LOAD_DATETIME desc) as rn
    from {{ ref('hub_part') }} p
    join {{ ref('sat_part') }} s on p.PART_HK = s.PART_HK
)
select
    part_hk,
    part_id,
    trim(part_name) as part_name,
    trim(brand) as brand,
    trim(type) as type,
    size,
    load_datetime,
    record_source
from part_latest
where rn = 1
