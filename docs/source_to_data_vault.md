# From Source to Data Vault entities

Este documento describe las entidades **Data Vault** implementadas/detectadas a partir del modelo origen TPCH (`SNOWFLAKE_SAMPLE_DATA.TPCH_SF1`).

> Nota: En este proyecto la capa `01_staging` construye **HKs** y **HASHDIFFs** con `automate_dv.stage()`, y la capa `02_raw_vault` materializa Hubs/Links/Satellites.

## Hubs (source → data vault)

| Hub (DV) | Modelo raw vault | Tabla source | Natural key (NK) en source | Hash key (HK) en staging |
|---|---|---|---|---|
| Customer | `hub_customer` | `CUSTOMER` | `C_CUSTKEY` | `CUSTOMER_HK` |
| Order | `hub_order` | `ORDERS` | `O_ORDERKEY` | `ORDER_HK` |
| Part | `hub_part` | `PART` | `P_PARTKEY` | `PART_HK` |
| Supplier | `hub_supplier` | `SUPPLIER` | `S_SUPPKEY` | `SUPPLIER_HK` |
| Nation (reference) | `hub_nation` | `NATION` | `N_NATIONKEY` | `NATION_HK` |
| Region (reference) | `hub_region` | `REGION` | `R_REGIONKEY` | `REGION_HK` |

## Links (source relationship → data vault)

| Link (DV) | Modelo raw vault | Relación / Tabla source | FKs en source | FKs (HKs) en staging | Link HK en staging |
|---|---|---|---|---|---|
| Order–Customer | `link_order_customer` | `ORDERS` | `O_ORDERKEY`, `O_CUSTKEY` | `ORDER_HK`, `CUSTOMER_HK` | `ORDER_CUSTOMER_HK` |
| Part–Supplier | `link_part_supplier` | `PARTSUPP` | `PS_PARTKEY`, `PS_SUPPKEY` | `PART_HK`, `SUPPLIER_HK` | `PART_SUPPLIER_HK` |
| Lineitem (Order–Part–Supplier) | `link_lineitem` | `LINEITEM` | `L_ORDERKEY`, `L_PARTKEY`, `L_SUPPKEY`, `L_LINENUMBER` | `ORDER_HK`, `PART_HK`, `SUPPLIER_HK` | `LINEITEM_HK` |

> Relaciones adicionales posibles (no implementadas como links explícitos hoy):
> - Customer–Nation (`CUSTOMER.C_NATIONKEY`)
> - Supplier–Nation (`SUPPLIER.S_NATIONKEY`)
> - Nation–Region (`NATION.N_REGIONKEY`)
>
> Estas relaciones pueden modelarse como links o mantenerse como atributos en satélites (decisión de diseño).

## Satellites (atributos por entidad)

| Satellite (DV) | Modelo raw vault | Contexto | Staging hashdiff | Atributos principales (payload) |
|---|---|---|---|---|
| Customer sat | `sat_customer` | Customer hub | `CUSTOMER_HASHDIFF` | `C_NAME`, `C_ADDRESS`, `C_PHONE`, `C_ACCTBAL`, `C_MKTSEGMENT` *(y opcionalmente `C_COMMENT`, `C_NATIONKEY`)* |
| Order sat | `sat_order` | Order hub | `ORDER_HASHDIFF` | `O_ORDERSTATUS`, `O_TOTALPRICE`, `O_ORDERPRIORITY`, `O_CLERK` *(y opcionalmente `O_ORDERDATE`, `O_SHIPPRIORITY`, `O_COMMENT`)* |
| Lineitem sat | `sat_lineitem` | Lineitem link | `LINEITEM_HASHDIFF` | `L_QUANTITY`, `L_EXTENDEDPRICE`, `L_DISCOUNT`, `L_TAX`, `L_RETURNFLAG`, `L_LINESTATUS` *(y opcionalmente fechas/instrucciones/comentario)* |
| Part sat | `sat_part` | Part hub | `PART_HASHDIFF` | `P_NAME`, `P_MFGR`, `P_BRAND`, `P_TYPE`, `P_SIZE`, `P_CONTAINER`, `P_RETAILPRICE` *(y opcionalmente `P_COMMENT`)* |
| Supplier sat | `sat_supplier` | Supplier hub | `SUPPLIER_HASHDIFF` | `S_NAME`, `S_ADDRESS`, `S_PHONE`, `S_ACCTBAL` *(y opcionalmente `S_COMMENT`, `S_NATIONKEY`)* |
| Part–Supplier sat | `sat_part_supplier` | Part–Supplier link | `PART_SUPPLIER_HASHDIFF` | `PS_AVAILQTY`, `PS_SUPPLYCOST` *(y opcionalmente `PS_COMMENT`)* |
| Order–Customer sat | `sat_order_customer` | Order–Customer link | `ORDER_CUSTOMER_HASHDIFF` | Técnicamente mínimo: `O_ORDERKEY`, `O_CUSTKEY` (para trazabilidad del link) |
| Nation sat | `sat_nation` | Nation hub | `NATION_HASHDIFF` | `N_NAME`, `N_REGIONKEY` *(y opcionalmente `N_COMMENT`)* |
| Region sat | `sat_region` | Region hub | `REGION_HASHDIFF` | `R_NAME` *(y opcionalmente `R_COMMENT`)* |