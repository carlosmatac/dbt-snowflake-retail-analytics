with customer_latest as (
    select
        c.CUSTOMER_HK as customer_hk,
        c.C_CUSTKEY as customer_id,
        s.C_NAME as customer_name,
        s.C_ADDRESS as address,
        s.C_PHONE as phone,
        s.C_ACCTBAL as account_balance,
        s.C_MKTSEGMENT as market_segment,
        ln.NATION_HK as nation_hk,
        s.C_COMMENT as comment,
        s.LOAD_DATETIME,
        row_number() over (
            partition by c.CUSTOMER_HK 
            order by s.LOAD_DATETIME desc
        ) as rn
    from {{ ref('hub_customer') }} c
    join {{ ref('sat_customer') }} s 
        on c.CUSTOMER_HK = s.CUSTOMER_HK
    join {{ ref('link_customer_nation') }} ln 
        on c.CUSTOMER_HK = ln.CUSTOMER_HK
),

customer_current as (
    select * from customer_latest where rn = 1
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
    r.region_name
from customer_current c
left join {{ ref('int_nation_current') }} n 
    on c.nation_hk = n.nation_hk
left join {{ ref('int_region_current') }} r 
    on n.region_hk = r.region_hk