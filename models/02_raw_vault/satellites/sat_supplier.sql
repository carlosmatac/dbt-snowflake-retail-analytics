{{ config(materialized='incremental') }}

{%- set source_model = "stg_tpch__supplier" -%}
{%- set src_pk = "SUPPLIER_HK" -%}
{%- set src_hashdiff = "SUPPLIER_HASHDIFF" -%}
{%- set src_payload = ["S_NAME", "S_ADDRESS", "S_PHONE", "S_ACCTBAL"] -%}
{%- set src_ldts = "LOAD_DATETIME" -%}
{%- set src_source = "RECORD_SOURCE" -%}

{{ automate_dv.sat(src_pk=src_pk, src_hashdiff=src_hashdiff, 
                   src_payload=src_payload, src_ldts=src_ldts, 
                   src_source=src_source, source_model=source_model) }}