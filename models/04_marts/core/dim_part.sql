-- Dimension: Part
-- Source: int_part_current

select
    part_hk,
    part_id,
    part_name,
    brand,
    type,
    size
from {{ ref('int_part_current') }}
