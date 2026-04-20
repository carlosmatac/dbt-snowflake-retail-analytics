with lineitem_current as (
    select
        l.LINEITEM_HK        as lineitem_hk,
        l.ORDER_HK           as order_hk,
        l.PART_HK            as part_hk,
        l.SUPPLIER_HK        as supplier_hk,
        s.L_QUANTITY         as quantity,
        s.L_EXTENDEDPRICE    as extended_price,
        s.L_DISCOUNT         as discount_percentage,
        s.L_TAX              as tax_percentage,
        s.L_SHIPDATE         as ship_date,
        s.L_COMMITDATE       as commit_date,
        s.L_RECEIPTDATE      as receipt_date,
        s.L_SHIPINSTRUCT     as ship_instruct,
        s.L_SHIPMODE         as ship_mode,
        s.L_COMMENT          as comment,
        s.LOAD_DATETIME      as load_datetime,
        s.RECORD_SOURCE      as record_source
    from {{ ref('link_lineitem') }} l
    inner join {{ ref('sat_lineitem') }} s
        on l.LINEITEM_HK = s.LINEITEM_HK
    qualify row_number() over (
        partition by l.LINEITEM_HK
        order by s.LOAD_DATETIME desc
    ) = 1
)

select
    l.lineitem_hk,
    l.order_hk,
    oc.CUSTOMER_HK                                     as customer_hk,
    l.part_hk,
    l.supplier_hk,
    o.order_date,
    l.ship_date,
    l.commit_date,
    l.receipt_date,
    cast(o.order_date    as date)                      as order_date_id,
    cast(l.ship_date     as date)                      as ship_date_id,
    cast(l.receipt_date  as date)                      as receipt_date_id,
    l.ship_instruct,
    l.ship_mode,
    l.comment,
    cast(l.quantity            as number(18,2))        as quantity,
    cast(l.extended_price      as number(18,4))        as extended_price,
    cast(l.discount_percentage as number(9,4))         as discount_percentage,
    cast(l.tax_percentage      as number(9,4))         as tax_percentage,
    cast(l.quantity as number(18,2))
        * cast(l.extended_price as number(18,4))       as item_total_price,
    cast(l.quantity as number(18,2))
        * cast(l.extended_price as number(18,4))
        * (1 - cast(l.discount_percentage as number(9,4))) as net_revenue,
    l.load_datetime,
    l.record_source
from lineitem_current l
left join {{ ref('pit_order') }}           o  on l.order_hk = o.order_hk
left join {{ ref('link_order_customer') }} oc on l.order_hk = oc.ORDER_HK
