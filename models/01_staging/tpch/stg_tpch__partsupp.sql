{%- set yaml_metadata -%}
source_model:
  tpch: 'partsupp'
derived_columns:
  RECORD_SOURCE: '!TPCH_SF1.PARTSUPP'
  LOAD_DATETIME: 'CURRENT_TIMESTAMP()'
hashed_columns:
  PART_HK: 'PS_PARTKEY'
  SUPPLIER_HK: 'PS_SUPPKEY'
  PART_SUPPLIER_HK:
    - 'PS_PARTKEY'
    - 'PS_SUPPKEY'
  PART_SUPPLIER_HASHDIFF:
    is_hashdiff: true
    columns:
      - 'PS_AVAILQTY'
      - 'PS_SUPPLYCOST'
      - 'PS_COMMENT'
{%- endset -%}

{% set metadata = fromyaml(yaml_metadata) %}

{{ automate_dv.stage(include_source_columns=true,
                     source_model=metadata['source_model'],
                     derived_columns=metadata['derived_columns'],
                     hashed_columns=metadata['hashed_columns'],
                     ranked_columns=none) }}