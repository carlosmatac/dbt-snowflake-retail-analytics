{{
    config(
        materialized='incremental',
        unique_key='order_id'
    )
}}
with orders as (
    select * from {{ ref('stg_tpch_orders') }}
    
    {% if is_incremental() %}
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
        -- Quitamos market_segment
        orders.order_date,
        orders.status as order_status_code, -- Renombramos status
        orders.total_price
    from orders
    left join customers on orders.customer_id = customers.customer_id
)

select * from final