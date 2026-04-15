{%- set yaml_metadata -%}
source_model: 
  tpch: 'supplier'
derived_columns:
  RECORD_SOURCE: '!TPCH_SF1.SUPPLIER'
  LOAD_DATETIME: 'CURRENT_TIMESTAMP()'
hashed_columns:
  SUPPLIER_HK: 'S_SUPPKEY'
  NATION_HK: 'S_NATIONKEY'
  SUPPLIER_NATION_HK:
    - 'S_SUPPKEY'
    - 'S_NATIONKEY'
  SUPPLIER_HASHDIFF:
    is_hashdiff: true
    columns:
      - 'S_NAME'
      - 'S_ADDRESS'
      - 'S_NATIONKEY'
      - 'S_PHONE'
      - 'S_ACCTBAL'
      - 'S_COMMENT'
{%- endset -%}

{% set metadata = fromyaml(yaml_metadata) %}

{{ automate_dv.stage(include_source_columns=true,
                     source_model=metadata['source_model'],
                     derived_columns=metadata['derived_columns'],
                     hashed_columns=metadata['hashed_columns'],
                     ranked_columns=none) }}