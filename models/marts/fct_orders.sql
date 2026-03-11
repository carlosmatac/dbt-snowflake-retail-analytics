{{ config(materialized='table') }}

with orders as (
    select * from {{ ref('stg_tpch_orders') }}
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