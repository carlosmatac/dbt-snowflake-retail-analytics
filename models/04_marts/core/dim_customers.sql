-- Dimension: Customers
-- Source: int_customer_current

select
    customer_hk,
    customer_id,
    customer_name,
    market_segment,
    nation_name,
    region_name
from {{ ref('int_customer_current') }}
