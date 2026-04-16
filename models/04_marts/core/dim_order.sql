-- Dimension: Order
-- Source: int_order_current

select
    order_hk,
    order_id,
    order_status,
    order_priority,
    clerk_name
from {{ ref('int_order_current') }}
