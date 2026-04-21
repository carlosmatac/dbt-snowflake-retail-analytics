select
    n.nation_hk,
    n.nation_id,
    n.nation_name,
    r.region_hk,
    r.region_id,
    r.region_name,
    n.load_datetime as nation_load_datetime,
    r.load_datetime as region_load_datetime
from {{ ref('bv_nation_current') }} n
left join {{ ref('bv_region_current') }} r
    on n.region_hk = r.region_hk
