{{ config(materialized='incremental') }}

{%- set source_model = "stg_tpch__lineitem" -%}
{%- set src_pk = "LINEITEM_HK" -%}
{%- set src_hashdiff = "LINEITEM_HASHDIFF" -%}
{%- set src_payload = ["L_QUANTITY", "L_EXTENDEDPRICE", "L_DISCOUNT", "L_TAX", "L_RETURNFLAG", "L_LINESTATUS"] -%}
{%- set src_ldts = "LOAD_DATETIME" -%}
{%- set src_source = "RECORD_SOURCE" -%}

{{ automate_dv.sat(src_pk=src_pk, src_hashdiff=src_hashdiff, 
                   src_payload=src_payload, src_ldts=src_ldts, 
                   src_source=src_source, source_model=source_model) }}