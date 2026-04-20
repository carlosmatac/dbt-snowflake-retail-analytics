{{ config(materialized='table') }}

-- PIT over link_lineitem + sat_lineitem. automate_dv.pit accepts links
-- as the parent entity as long as src_pk matches the link PK.

{%- set yaml_metadata -%}
source_model: "stg_tpch__lineitem"
src_pk: "LINEITEM_HK"
as_of_dates_table: "as_of_date"
satellites:
  sat_lineitem:
    pk:
      PK: "LINEITEM_HK"
    ldts:
      LDTS: "LOAD_DATETIME"
stage_tables_ldts:
  stg_tpch__lineitem: "LOAD_DATETIME"
{%- endset -%}

{% set metadata = fromyaml(yaml_metadata) %}

{{ automate_dv.pit(
    source_model      = metadata['source_model'],
    src_pk            = metadata['src_pk'],
    as_of_dates_table = metadata['as_of_dates_table'],
    satellites        = metadata['satellites'],
    stage_tables_ldts = metadata['stage_tables_ldts']
) }}
