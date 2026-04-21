# From Source to Data Vault entities

Este documento describe las entidades **Data Vault** implementadas a partir del modelo origen TPCH (`SNOWFLAKE_SAMPLE_DATA.TPCH_SF1`).

En este proyecto la capa `01_staging` construye **HKs** y **HASHDIFFs** con `automate_dv.stage()`, y la capa `02_raw_vault` materializa Hubs, Links y Satellites.

**Fuente de verdad:** los listados de atributos en satélites coinciden con el array `src_payload` de cada modelo `models/02_raw_vault/satellites/sat_*.sql`. Si este documento y el código difieren, prevalece el código.

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
| Customer–Nation | `link_customer_nation` | `CUSTOMER` | `C_CUSTKEY`, `C_NATIONKEY` | `CUSTOMER_HK`, `NATION_HK` | `CUSTOMER_NATION_HK` |
| Order–Customer | `link_order_customer` | `ORDERS` | `O_ORDERKEY`, `O_CUSTKEY` | `ORDER_HK`, `CUSTOMER_HK` | `ORDER_CUSTOMER_HK` |
| Part–Supplier | `link_part_supplier` | `PARTSUPP` | `PS_PARTKEY`, `PS_SUPPKEY` | `PART_HK`, `SUPPLIER_HK` | `PART_SUPPLIER_HK` |
| Lineitem (Order–Part–Supplier) | `link_lineitem` | `LINEITEM` | `L_ORDERKEY`, `L_PARTKEY`, `L_SUPPKEY`, `L_LINENUMBER` | `ORDER_HK`, `PART_HK`, `SUPPLIER_HK` | `LINEITEM_HK` |
| Supplier–Nation | `link_supplier_nation` | `SUPPLIER` | `S_SUPPKEY`, `S_NATIONKEY` | `SUPPLIER_HK`, `NATION_HK` | `SUPPLIER_NATION_HK` |
| Nation–Region | `link_nation_region` | `NATION` | `N_NATIONKEY`, `N_REGIONKEY` | `NATION_HK`, `REGION_HK` | `NATION_REGION_HK` |

La relación **Order–Customer** se modela solo con el **link** `link_order_customer`. **No hay** modelo `sat_order_customer` ni satélite de link equivalente: las claves naturales siguen en la fuente `ORDERS` y el vínculo queda en el link.

Las claves de geografía (`C_NATIONKEY`, `S_NATIONKEY`, `N_REGIONKEY`) no se repiten en los satélites de hub de customer/supplier/nation; esas relaciones están en los links anteriores.

## Satellites (atributos por entidad)

Cada fila lista exactamente las columnas del `src_payload` del satélite correspondiente (más metadatos estándar que añade `automate_dv.sat`: por ejemplo `LOAD_DATETIME`, `RECORD_SOURCE`, hashdiff, etc.).

| Satellite (DV) | Modelo raw vault | Contexto | Staging hashdiff | Payload (`src_payload`) |
|---|---|---|---|---|
| Customer sat | `sat_customer` | Customer hub | `CUSTOMER_HASHDIFF` | `C_NAME`, `C_ADDRESS`, `C_PHONE`, `C_ACCTBAL`, `C_MKTSEGMENT`, `C_COMMENT` |
| Order sat | `sat_order` | Order hub | `ORDER_HASHDIFF` | `O_ORDERSTATUS`, `O_TOTALPRICE`, `O_ORDERPRIORITY`, `O_CLERK`, `O_ORDERDATE`, `O_SHIPPRIORITY`, `O_COMMENT` |
| Lineitem sat | `sat_lineitem` | Lineitem link | `LINEITEM_HASHDIFF` | `L_QUANTITY`, `L_EXTENDEDPRICE`, `L_DISCOUNT`, `L_TAX`, `L_RETURNFLAG`, `L_LINESTATUS`, `L_SHIPDATE`, `L_COMMITDATE`, `L_RECEIPTDATE`, `L_SHIPINSTRUCT`, `L_SHIPMODE`, `L_COMMENT` |
| Part sat | `sat_part` | Part hub | `PART_HASHDIFF` | `P_NAME`, `P_MFGR`, `P_BRAND`, `P_TYPE`, `P_SIZE`, `P_CONTAINER`, `P_RETAILPRICE`, `P_COMMENT` |
| Supplier sat | `sat_supplier` | Supplier hub | `SUPPLIER_HASHDIFF` | `S_NAME`, `S_ADDRESS`, `S_PHONE`, `S_ACCTBAL`, `S_COMMENT` |
| Part–Supplier sat | `sat_part_supplier` | Part–Supplier link | `PART_SUPPLIER_HASHDIFF` | `PS_AVAILQTY`, `PS_SUPPLYCOST`, `PS_COMMENT` |
| Nation sat | `sat_nation` | Nation hub | `NATION_HASHDIFF` | `N_NAME`, `N_COMMENT` |
| Region sat | `sat_region` | Region hub | `REGION_HASHDIFF` | `R_NAME`, `R_COMMENT` |
