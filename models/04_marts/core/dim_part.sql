select
    part_hk,
    part_id,
    part_name,
    brand,
    part_type,
    part_size
from {{ ref('pit_part') }}
