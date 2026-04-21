select
    customer_hk,
    customer_id,
    customer_name,
    market_segment,
    nation_name,
    region_name
from {{ ref('bv_customer_current') }}
