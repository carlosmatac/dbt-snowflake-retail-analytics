{%- set yaml_metadata -%}
source_model:
  tpch: 'orders'
derived_columns:
  RECORD_SOURCE: '!TPCH_SF1.ORDERS'
  LOAD_DATETIME: 'CURRENT_TIMESTAMP()'
hashed_columns:
  ORDER_HK: 'O_ORDERKEY'
  CUSTOMER_HK: 'O_CUSTKEY'
  ORDER_CUSTOMER_HK:
    - 'O_ORDERKEY'
    - 'O_CUSTKEY'
  ORDER_CUSTOMER_HASHDIFF:
    is_hashdiff: true
    columns:
      - 'O_ORDERKEY'
      - 'O_CUSTKEY'
  ORDER_HASHDIFF:
    is_hashdiff: true
    columns:
      - 'O_ORDERSTATUS'
      - 'O_TOTALPRICE'
      - 'O_ORDERDATE'
      - 'O_ORDERPRIORITY'
      - 'O_CLERK'
      - 'O_SHIPPRIORITY'
      - 'O_COMMENT'
{%- endset -%}

{% set metadata = fromyaml(yaml_metadata) %}

{{ automate_dv.stage(include_source_columns=true,
                     source_model=metadata['source_model'],
                     derived_columns=metadata['derived_columns'],
                     hashed_columns=metadata['hashed_columns'],
                     ranked_columns=none) }}