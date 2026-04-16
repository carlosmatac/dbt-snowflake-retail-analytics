-- Fact Table: Sales (Lineitem grain)
-- Source: int_lineitem_sales

select
    lineitem_hk,
    order_hk,
    customer_hk,
    part_hk,
    supplier_hk,
    order_date,
    ship_date,
    receipt_date,
    quantity,
    extended_price,
    discount_percentage,
    tax_percentage,
    item_total_price,
    net_revenue
from {{ ref('int_lineitem_sales') }}
