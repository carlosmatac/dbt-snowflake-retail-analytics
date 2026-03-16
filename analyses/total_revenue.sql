-- analyses/total_revenue.sql
-- Calculamos los ingresos totales solo de los pedidos finalizados ('F')

select 
    sum(total_price) as total_revenue 
from {{ ref('stg_tpch_orders') }}
where status = 'F'