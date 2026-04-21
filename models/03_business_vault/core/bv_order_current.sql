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
inner join {{ ref('pit_order') }} p
    on h.ORDER_HK = p.ORDER_HK
inner join {{ ref('sat_order') }} s
    on p.SAT_ORDER_PK   = s.ORDER_HK
   and p.SAT_ORDER_LDTS = s.LOAD_DATETIME
