-- models/01_staging/tpch/stg_tpch__customers.sql

{%- set yaml_metadata -%}
source_model:
  tpch: 'customer'
derived_columns:
  RECORD_SOURCE: '!TPCH_SF1.CUSTOMER'
  LOAD_DATETIME: 'CURRENT_TIMESTAMP()'
hashed_columns:
  CUSTOMER_HK: 'C_CUSTKEY'
  CUSTOMER_HASHDIFF:
    is_hashdiff: true
    columns:
      - 'C_NAME'
      - 'C_ADDRESS'
      - 'C_NATIONKEY'
      - 'C_PHONE'
      - 'C_ACCTBAL'
      - 'C_MKTSEGMENT'
      - 'C_COMMENT'
{%- endset -%}

{% set metadata = fromyaml(yaml_metadata) %}

{{ automate_dv.stage(include_source_columns=true,
                     source_model=metadata['source_model'],
                     derived_columns=metadata['derived_columns'],
                     hashed_columns=metadata['hashed_columns'],
                     ranked_columns=none) }}