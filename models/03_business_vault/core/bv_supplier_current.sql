with supplier_current as (
    select
        h.SUPPLIER_HK                  as supplier_hk,
        h.S_SUPPKEY                    as supplier_id,
        trim(s.S_NAME)                 as supplier_name,
        trim(s.S_ADDRESS)              as address,
        trim(s.S_PHONE)                as phone,
        s.S_ACCTBAL                    as account_balance,
        ln.NATION_HK                   as nation_hk,
        s.LOAD_DATETIME                as load_datetime,
        s.RECORD_SOURCE                as record_source
    from {{ ref('hub_supplier') }} h
    inner join {{ ref('pit_supplier') }} p
        on h.SUPPLIER_HK = p.SUPPLIER_HK
    inner join {{ ref('sat_supplier') }} s
        on p.SAT_SUPPLIER_PK   = s.SUPPLIER_HK
       and p.SAT_SUPPLIER_LDTS = s.LOAD_DATETIME
    left join {{ ref('link_supplier_nation') }} ln
        on h.SUPPLIER_HK = ln.SUPPLIER_HK
)

select
    s.supplier_hk,
    s.supplier_id,
    s.supplier_name,
    s.address,
    s.phone,
    s.account_balance,
    s.nation_hk,
    l.nation_name,
    l.region_hk,
    l.region_name,
    s.load_datetime,
    s.record_source
from supplier_current s
left join {{ ref('bv_location_current') }} l
    on s.nation_hk = l.nation_hk
