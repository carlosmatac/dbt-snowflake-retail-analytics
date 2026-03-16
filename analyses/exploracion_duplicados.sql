-- Buscamos si algún ID de cliente aparece más de una vez
select 
    customer_id, 
    count(*) as conteo
from {{ ref('stg_tpch_customers') }} 
group by customer_id 
having count(*) > 1