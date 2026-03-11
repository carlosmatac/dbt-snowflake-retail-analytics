select
    c_custkey as customer_id,
    c_name as name,
    c_address as address,
    c_nationkey as nation_id,
    c_phone as phone_number,
    c_mktsegment as market_segment
from {{ source('tpch_sample_data', 'customer') }}