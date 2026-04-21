select
    supplier_hk,
    supplier_id,
    supplier_name,
    nation_name,
    region_name
from {{ ref('bv_supplier_current') }}
