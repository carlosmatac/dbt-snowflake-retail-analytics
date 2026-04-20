{{ config(
    materialized='incremental',
    unique_key='lineitem_hk',
    on_schema_change='append_new_columns'
) }}

select
    lineitem_hk,
    order_hk,
    customer_hk,
    part_hk,
    supplier_hk,
    order_date_id,
    ship_date_id,
    receipt_date_id,
    order_date,
    ship_date,
    receipt_date,
    quantity,
    extended_price,
    discount_percentage,
    tax_percentage,
    item_total_price,
    net_revenue,
    load_datetime
from {{ ref('pit_lineitem_sales') }}

{% if is_incremental() %}
where load_datetime > (select coalesce(max(load_datetime), '1900-01-01'::timestamp) from {{ this }})
{% endif %}
