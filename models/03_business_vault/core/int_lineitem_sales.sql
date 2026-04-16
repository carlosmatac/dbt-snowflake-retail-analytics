-- Intermediate model: Lineitem sales (Business Vault)
-- Flattens link_lineitem + latest sat_lineitem + order date + customer_hk

with lineitem_latest as (
    select
        l.LINEITEM_HK as lineitem_hk,
        l.ORDER_HK as order_hk,
        l.PART_HK as part_hk,
        l.SUPPLIER_HK as supplier_hk,
        s.L_QUANTITY as quantity,
        s.L_EXTENDEDPRICE as extended_price,
        s.L_DISCOUNT as discount_percentage,
        s.L_TAX as tax_percentage,
        s.L_SHIPDATE as ship_date,
        s.L_COMMITDATE as commit_date,
        s.L_RECEIPTDATE as receipt_date,
        s.L_SHIPINSTRUCT as ship_instruct,
        s.L_SHIPMODE as ship_mode,
        s.L_COMMENT as comment,
        s.LOAD_DATETIME as load_datetime,
        s.RECORD_SOURCE as record_source,
        row_number() over (partition by l.LINEITEM_HK order by s.LOAD_DATETIME desc) as rn
    from {{ ref('link_lineitem') }} l
    join {{ ref('sat_lineitem') }} s on l.LINEITEM_HK = s.LINEITEM_HK
),
lineitem_current as (
    select * from lineitem_latest where rn = 1
),
order_dates as (
    select order_hk, o_orderdate as order_date from {{ ref('sat_order') }}
),
order_customer as (
    select order_hk, customer_hk from {{ ref('link_order_customer') }}
)
select
    l.lineitem_hk,
    l.order_hk,
    oc.customer_hk,
    l.part_hk,
    l.supplier_hk,
    od.order_date,
    l.ship_date,
    l.commit_date,
    l.receipt_date,
    l.ship_instruct,
    l.ship_mode,
    l.comment,
    l.quantity,
    l.extended_price,
    l.discount_percentage,
    l.tax_percentage,
    l.quantity * l.extended_price as item_total_price,
    (l.quantity * l.extended_price) * (1 - l.discount_percentage) as net_revenue,
    l.load_datetime,
    l.record_source
from lineitem_current l
left join order_dates od on l.order_hk = od.order_hk
left join order_customer oc on l.order_hk = oc.order_hk
