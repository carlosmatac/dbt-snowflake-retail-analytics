-- Dimension: Supplier
-- Source: int_supplier_current

select
    supplier_hk,
    supplier_id,
    supplier_name,
    nation_name,
    region_name
from {{ ref('int_supplier_current') }}
