select
    lineitem_hk,
    quantity,
    extended_price,
    discount_percentage,
    net_revenue
from {{ ref('fct_sales') }}
where net_revenue < 0
