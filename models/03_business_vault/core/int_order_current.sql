-- Intermediate model: Order current state (Business Vault)
-- Flattens hub_order + latest sat_order

with order_latest as (
    select
        o.ORDER_HK as order_hk,
        o.O_ORDERKEY as order_id,
        s.O_ORDERSTATUS as order_status,
        s.O_ORDERPRIORITY as order_priority,
        s.O_CLERK as clerk_name,
        s.LOAD_DATETIME as load_datetime,
        s.RECORD_SOURCE as record_source,
        row_number() over (partition by o.ORDER_HK order by s.LOAD_DATETIME desc) as rn
    from {{ ref('hub_order') }} o
    join {{ ref('sat_order') }} s on o.ORDER_HK = s.ORDER_HK
)
select
    order_hk,
    order_id,
    order_status,
    order_priority,
    clerk_name,
    load_datetime,
    record_source
from order_latest
where rn = 1
