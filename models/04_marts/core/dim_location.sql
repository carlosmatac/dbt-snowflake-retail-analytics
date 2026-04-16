-- Dimension: Location
-- Source: int_location_current

select
    nation_hk,
    nation_id,
    nation_name,
    region_hk,
    region_id,
    region_name
from {{ ref('int_location_current') }}
