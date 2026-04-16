with supplier_latest as (
    select
        s.SUPPLIER_HK as supplier_hk,
        s.S_SUPPKEY as supplier_id,
        st.S_NAME as supplier_name,
        st.S_ADDRESS as address,
        st.S_PHONE as phone,
        st.S_ACCTBAL as account_balance,
        ln.NATION_HK as nation_hk,
        st.S_COMMENT as comment,
        st.LOAD_DATETIME,
        row_number() over (
            partition by s.SUPPLIER_HK 
            order by st.LOAD_DATETIME desc
        ) as rn
    from {{ ref('hub_supplier') }} s
    join {{ ref('sat_supplier') }} st 
        on s.SUPPLIER_HK = st.SUPPLIER_HK
    join {{ ref('link_supplier_nation') }} ln 
        on s.SUPPLIER_HK = ln.SUPPLIER_HK
),

supplier_current as (
    select * from supplier_latest where rn = 1
)

select
    s.supplier_hk,
    s.supplier_id,
    trim(s.supplier_name) as supplier_name,
    trim(s.address) as address,
    trim(s.phone) as phone,
    s.account_balance,
    n.nation_name,
    r.region_name
from supplier_current s
left join {{ ref('int_nation_current') }} n 
    on s.nation_hk = n.nation_hk
left join {{ ref('int_region_current') }} r 
    on n.region_hk = r.region_hk