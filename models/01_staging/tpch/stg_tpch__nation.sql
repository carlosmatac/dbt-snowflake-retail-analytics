{%- set yaml_metadata -%}
source_model: 
  tpch: 'nation'
derived_columns:
  RECORD_SOURCE: '!TPCH_SF1.NATION'
  LOAD_DATETIME: 'CURRENT_TIMESTAMP()'
hashed_columns:
  NATION_HK: 'N_NATIONKEY'
  NATION_HASHDIFF:
    is_hashdiff: true
    columns:
      - 'N_NAME'
      - 'N_REGIONKEY'
      - 'N_COMMENT'
{%- endset -%}

{% set metadata = fromyaml(yaml_metadata) %}

{{ automate_dv.stage(include_source_columns=true,
                     source_model=metadata['source_model'],
                     derived_columns=metadata['derived_columns'],
                     hashed_columns=metadata['hashed_columns'],
                     ranked_columns=none) }}
