select
    order_hk,
    order_id,
    order_status,
    order_priority,
    clerk_name,
    order_date,
    cast(order_date as date) as order_date_id
from {{ ref('bv_order_current') }}
