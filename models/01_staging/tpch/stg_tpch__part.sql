{%- set yaml_metadata -%}
source_model: 
  tpch: 'part'
derived_columns:
  RECORD_SOURCE: '!TPCH_SF1.PART'
  LOAD_DATETIME: 'CURRENT_TIMESTAMP()'
hashed_columns:
  PART_HK: 'P_PARTKEY'
  PART_HASHDIFF:
    is_hashdiff: true
    columns:
      - 'P_NAME'
      - 'P_MFGR'
      - 'P_BRAND'
      - 'P_TYPE'
      - 'P_SIZE'
      - 'P_CONTAINER'
      - 'P_RETAILPRICE'
{%- endset -%}

{% set metadata = fromyaml(yaml_metadata) %}

{{ automate_dv.stage(include_source_columns=true,
                     source_model=metadata['source_model'],
                     derived_columns=metadata['derived_columns'],
                     hashed_columns=metadata['hashed_columns'],
                     ranked_columns=none) }}