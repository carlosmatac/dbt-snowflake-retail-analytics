with customer_current as (
    select
        h.CUSTOMER_HK                      as customer_hk,
        h.C_CUSTKEY                        as customer_id,
        trim(s.C_NAME)                     as customer_name,
        trim(s.C_ADDRESS)                  as address,
        trim(s.C_PHONE)                    as phone,
        s.C_ACCTBAL                        as account_balance,
        upper(trim(s.C_MKTSEGMENT))        as market_segment,
        ln.NATION_HK                       as nation_hk,
        s.LOAD_DATETIME                    as load_datetime,
        s.RECORD_SOURCE                    as record_source
    from {{ ref('hub_customer') }} h
    inner join {{ ref('pit_customer') }} p
        on h.CUSTOMER_HK = p.CUSTOMER_HK
    inner join {{ ref('sat_customer') }} s
        on p.SAT_CUSTOMER_PK   = s.CUSTOMER_HK
       and p.SAT_CUSTOMER_LDTS = s.LOAD_DATETIME
    left join {{ ref('link_customer_nation') }} ln
        on h.CUSTOMER_HK = ln.CUSTOMER_HK
)

select
    c.customer_hk,
    c.customer_id,
    c.customer_name,
    c.address,
    c.phone,
    c.account_balance,
    c.market_segment,
    c.nation_hk,
    l.nation_name,
    l.region_hk,
    l.region_name,
    c.load_datetime,
    c.record_source
from customer_current c
left join {{ ref('bv_location_current') }} l
    on c.nation_hk = l.nation_hk
