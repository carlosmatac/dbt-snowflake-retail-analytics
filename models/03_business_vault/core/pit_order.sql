select
    h.ORDER_HK          as order_hk,
    h.O_ORDERKEY        as order_id,
    s.O_ORDERSTATUS     as order_status,
    s.O_ORDERPRIORITY   as order_priority,
    s.O_CLERK           as clerk_name,
    s.O_ORDERDATE       as order_date,
    s.LOAD_DATETIME     as load_datetime,
    s.RECORD_SOURCE     as record_source
from {{ ref('hub_order') }} h
inner join {{ ref('sat_order') }} s
    on h.ORDER_HK = s.ORDER_HK
qualify row_number() over (
    partition by h.ORDER_HK
    order by s.LOAD_DATETIME desc
) = 1
