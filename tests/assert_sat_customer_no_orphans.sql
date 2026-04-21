select s.CUSTOMER_HK
from {{ ref('sat_customer') }} s
left join {{ ref('hub_customer') }} h
    on s.CUSTOMER_HK = h.CUSTOMER_HK
where h.CUSTOMER_HK is null
