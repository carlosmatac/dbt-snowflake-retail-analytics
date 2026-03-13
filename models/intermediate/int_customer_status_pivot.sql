{%- set order_statuses = ['O', 'P', 'F'] -%}

with orders as (
    select * from {{ ref('fct_orders') }}
),

final as (
    select
        customer_id,
        
        {% for status in order_statuses -%}
        sum(
            case
                when status = '{{ status }}' then total_price else 0
            end
        ) as amount_{{ status }}
        {%- if not loop.last -%} , {%- endif %}
        
        {%- endfor %}
        
    from orders
    group by 1
)

select * from final