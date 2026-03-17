-- 1. Escribimos la query del sistema viejo (y renombramos la PK para que coincida)
{% set old_etl_query %}
    select 
        o_orderkey as order_id, 
        o_custkey as customer_id
    from {{ source('tpch_sample_data', 'orders') }}
{% endset %}

-- 2. Escribimos la query de tu nuevo modelo dbt
{% set dbt_query %}
    select 
        order_id,
        customer_id
    from {{ ref('stg_tpch_orders') }}
{% endset %}

-- 3. Usamos la macro COMPARE_QUERIES (no relations)
{{ audit_helper.compare_queries(
    a_query=old_etl_query,
    b_query=dbt_query,
    primary_key="order_id"
) }}