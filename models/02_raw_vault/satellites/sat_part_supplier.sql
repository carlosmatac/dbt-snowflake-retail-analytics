{{ config(materialized='incremental') }}

{%- set source_model = "stg_tpch__partsupp" -%}
{%- set src_pk = "PART_SUPPLIER_HK" -%}
{%- set src_hashdiff = "PART_SUPPLIER_HASHDIFF" -%}
{%- set src_payload = ["PS_AVAILQTY", "PS_SUPPLYCOST", "PS_COMMENT"] -%}
{%- set src_ldts = "LOAD_DATETIME" -%}
{%- set src_source = "RECORD_SOURCE" -%}

{{ automate_dv.sat(src_pk=src_pk, src_hashdiff=src_hashdiff, 
                   src_payload=src_payload, src_ldts=src_ldts, 
                   src_source=src_source, source_model=source_model) }}