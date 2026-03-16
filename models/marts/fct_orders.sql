
{{
    config(
        materialized='incremental',
        unique_key='order_id'
    )
}}
with orders as (
    select * from {{ ref('stg_tpch_orders') }}
    
    -- AQUÍ ESTÁ LA MAGIA INCREMENTAL
    {% if is_incremental() %}
        -- Coge solo los pedidos cuya fecha sea mayor que la última fecha 
        -- que ya tenemos insertada en esta misma tabla ( {{ this }} )
        where order_date >= (select max(order_date) from {{ this }})
    {% endif %}
),

customers as (
    select * from {{ ref('stg_tpch_customers') }}
),

final as (
    select
        orders.order_id,
        orders.customer_id,
        customers.name as customer_name,
        customers.market_segment,
        orders.order_date,
        orders.status,
        orders.total_price
    from orders
    left join customers on orders.customer_id = customers.customer_id
)

select * from final