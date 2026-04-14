{{ config(materialized='incremental') }}

{%- set source_model = "stg_tpch__lineitem" -%}
{%- set src_pk = "LINEITEM_HK" -%}
{%- set src_fk = ["ORDER_HK", "PART_HK", "SUPPLIER_HK"] -%}
{%- set src_ldts = "LOAD_DATETIME" -%}
{%- set src_source = "RECORD_SOURCE" -%}

{{ automate_dv.link(src_pk=src_pk, src_fk=src_fk, 
                    src_ldts=src_ldts, src_source=src_source, 
                    source_model=source_model) }}