{%- set yaml_metadata -%}
source_model: 
  tpch: 'lineitem'
derived_columns:
  RECORD_SOURCE: '!TPCH_SF1.LINEITEM'
  LOAD_DATETIME: 'CURRENT_TIMESTAMP()'
hashed_columns:
  LINEITEM_HK: 
    - 'L_ORDERKEY'
    - 'L_PARTKEY'
    - 'L_SUPPKEY'
    - 'L_LINENUMBER'
  ORDER_HK: 'L_ORDERKEY'
  PART_HK: 'L_PARTKEY'
  SUPPLIER_HK: 'L_SUPPKEY'

  LINEITEM_HASHDIFF:
    is_hashdiff: true
    columns:
      - 'L_QUANTITY'
      - 'L_EXTENDEDPRICE'
      - 'L_DISCOUNT'
      - 'L_TAX'
      - 'L_RETURNFLAG'
      - 'L_LINESTATUS'
{%- endset -%}

{% set metadata = fromyaml(yaml_metadata) %}

{{ automate_dv.stage(include_source_columns=true,
                     source_model=metadata['source_model'],
                     derived_columns=metadata['derived_columns'],
                     hashed_columns=metadata['hashed_columns'],
                     ranked_columns=none) }}