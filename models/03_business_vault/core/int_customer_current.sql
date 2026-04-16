-- Intermediate model: Customer current state (Business Vault)
-- Flattens hub_customer + latest sat_customer + nation/region

with customer_latest as (
    select
        c.CUSTOMER_HK as customer_hk,
        c.C_CUSTKEY as customer_id,
        s.C_NAME as customer_name,
        s.C_ADDRESS as address,
        s.C_PHONE as phone,
        s.C_ACCTBAL as account_balance,
        s.C_MKTSEGMENT as market_segment,
        ln.NATION_HK as nation_id,
        s.C_COMMENT as comment,
        s.LOAD_DATETIME as load_datetime,
        s.RECORD_SOURCE as record_source,
        row_number() over (partition by c.CUSTOMER_HK order by s.LOAD_DATETIME desc) as rn
    from {{ ref('hub_customer') }} c
    join {{ ref('sat_customer') }} s on c.CUSTOMER_HK = s.CUSTOMER_HK
    join {{ ref('link_customer_nation') }} ln on c.CUSTOMER_HK = ln.CUSTOMER_HK
),
customer_current as (
    select * from customer_latest where rn = 1
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
    c.customer_hk,
    c.customer_id,
    trim(c.customer_name) as customer_name,
    trim(c.address) as address,
    trim(c.phone) as phone,
    c.account_balance,
    upper(trim(c.market_segment)) as market_segment,
    n.nation_name,
    rg.region_name,
    c.load_datetime,
    c.record_source
from customer_current c
left join nation n on c.nation_id = n.NATION_HK
left join region rg on n.region_id = rg.REGION_HK
