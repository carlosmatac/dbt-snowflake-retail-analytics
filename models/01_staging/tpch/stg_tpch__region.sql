{%- set yaml_metadata -%}
source_model: 
  tpch: 'region'
derived_columns:
  RECORD_SOURCE: '!TPCH_SF1.REGION'
  LOAD_DATETIME: 'CURRENT_TIMESTAMP()'
hashed_columns:
  REGION_HK: 'R_REGIONKEY'
  REGION_HASHDIFF:
    is_hashdiff: true
    columns:
      - 'R_NAME'
      - 'R_COMMENT'
{%- endset -%}

{% set metadata = fromyaml(yaml_metadata) %}

{{ automate_dv.stage(include_source_columns=true,
                     source_model=metadata['source_model'],
                     derived_columns=metadata['derived_columns'],
                     hashed_columns=metadata['hashed_columns'],
                     ranked_columns=none) }}
