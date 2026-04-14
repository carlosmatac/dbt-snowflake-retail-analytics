{{ config(materialized='incremental') }}

{%- set source_model = "stg_tpch__nation" -%}
{%- set src_pk = "NATION_HK" -%}
{%- set src_hashdiff = "NATION_HASHDIFF" -%}
{%- set src_payload = ["N_NAME", "N_REGIONKEY"] -%}
{%- set src_ldts = "LOAD_DATETIME" -%}
{%- set src_source = "RECORD_SOURCE" -%}

{{ automate_dv.sat(src_pk=src_pk, src_hashdiff=src_hashdiff, 
                   src_payload=src_payload, src_ldts=src_ldts, 
                   src_source=src_source, source_model=source_model) }}
