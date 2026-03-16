-- Este test busca pedidos que tengan un precio total negativo.
-- Si devuelve 0 filas, el test pasa. Si devuelve 1 o más, el test falla.
{{ config(enabled = false) }}

select
    order_id,
    total_price
from {{ ref('stg_tpch_orders') }}
where total_price < 0