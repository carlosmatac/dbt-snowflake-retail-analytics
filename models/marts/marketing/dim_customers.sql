
with customers as (
    select * from {{ ref('stg_tpch_customers') }}
),

orders as ( 
    select * from {{ ref('fct_orders') }}
),

-- ¡NUEVO! Nos traemos tu tabla pivotada de Jinja
status_pivot as (
    select * from {{ ref('int_customer_status_pivot') }}
),

customer_orders as (
    select
        customer_id,
        min(order_date) as first_order_date,
        max(order_date) as most_recent_order_date,
        count(order_id) as number_of_orders,
        sum(total_price) as lifetime_value
    from orders
    group by 1
),

final as (
    select
        customers.customer_id,
        customers.name as customer_name,
        customers.market_segment,
        customer_orders.first_order_date,
        customer_orders.most_recent_order_date,
        coalesce(customer_orders.number_of_orders, 0) as number_of_orders,
        coalesce(customer_orders.lifetime_value, 0) as lifetime_value,
        
        -- ¡NUEVO! Añadimos las columnas pivotadas a la tabla final
        coalesce(status_pivot.amount_O, 0) as amount_open,
        coalesce(status_pivot.amount_P, 0) as amount_pending,
        coalesce(status_pivot.amount_F, 0) as amount_finalized

    from customers
    left join customer_orders using (customer_id)
    -- ¡NUEVO! Hacemos el cruce
    left join status_pivot using (customer_id)
)

select * from final