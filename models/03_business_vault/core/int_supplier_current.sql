-- Intermediate model: Supplier current state (Business Vault)
-- Flattens hub_supplier + latest sat_supplier + nation/region

with supplier_latest as (
    select
        s.SUPPLIER_HK as supplier_hk,
        s.S_SUPPKEY as supplier_id,
        st.S_NAME as supplier_name,
        st.S_ADDRESS as address,
        st.S_PHONE as phone,
        st.S_ACCTBAL as account_balance,
        ln.S_NATIONKEY as nation_id,
        st.S_COMMENT as comment,
        st.LOAD_DATETIME as load_datetime,
        st.RECORD_SOURCE as record_source,
        row_number() over (partition by s.SUPPLIER_HK order by st.LOAD_DATETIME desc) as rn
    from {{ ref('hub_supplier') }} s
    join {{ ref('sat_supplier') }} st on s.SUPPLIER_HK = st.SUPPLIER_HK
    join {{ ref('link_supplier_nation') }} ln on s.SUPPLIER_HK = ln.SUPPLIER_HK
),
supplier_current as (
    select * from supplier_latest where rn = 1
),
nation as (
    select
        n.NATION_HK,
        n.N_NATIONKEY as nation_id,
        sn.N_NAME as nation_name,
        sn.N_REGIONKEY as region_id
    from {{ ref('hub_nation') }} n
    join {{ ref('sat_nation') }} sn on n.NATION_HK = sn.NATION_HK
),
region as (
    select
        r.REGION_HK,
        r.R_REGIONKEY as region_id,
        sr.R_NAME as region_name
    from {{ ref('hub_region') }} r
    join {{ ref('sat_region') }} sr on r.REGION_HK = sr.REGION_HK
)
select
    s.supplier_hk,
    s.supplier_id,
    trim(s.supplier_name) as supplier_name,
    trim(s.address) as address,
    trim(s.phone) as phone,
    s.account_balance,
    n.nation_name,
    rg.region_name,
    s.load_datetime,
    s.record_source
from supplier_current s
left join nation n on s.nation_id = n.NATION_HK
left join region rg on n.region_id = rg.REGION_HK
