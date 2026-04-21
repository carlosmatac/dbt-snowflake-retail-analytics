# Retail Insights — dbt en Snowflake (TPCH + Data Vault + Star Schema)

Proyecto **dbt** (`retail_insights`) sobre **Snowflake** usando el dataset de ejemplo **TPCH** (`SNOWFLAKE_SAMPLE_DATA.TPCH_SF1`). El modelado sigue un recorrido en capas: **staging → Raw Data Vault → Business Vault → marts (esquema en estrella)**.

## Stack

| Componente | Detalle |
|------------|---------|
| Almacén | Snowflake |
| Dataset | `SNOWFLAKE_SAMPLE_DATA.TPCH_SF1` (definido en `models/01_staging/tpch/_tpch__sources.yml`) |
| Transformación | **dbt** |
| Data Vault | **Datavault-UK/automate_dv** (`packages.yml`) |
| Utilidades | **dbt-labs/dbt_utils** |

## Arquitectura de capas

1. **Staging** — Vistas/tablas 1:1 desde fuentes; preparación de columnas y hashes para DV (`automate_dv.stage()` donde aplique).
2. **Raw Data Vault** — Hubs, links y satélites incrementales para historificación y trazabilidad (`hub`, `link`, `sat`).
3. **Business Vault** — Capa de negocio sobre el Raw Vault: **PITs** (`pit_*` con `automate_dv.pit`), spine `as_of_date`, y vistas **`bv_*`** (estado actual y hechos de negocio como `bv_lineitem_sales`).
4. **Marts** — Consumo analítico en **esquema en estrella**: dimensiones (`dim_*`) y hechos (`fct_sales`), con claves surrogate basadas en **hash keys** del Data Vault para mantener linaje.

Documentación de diseño más detallada: `docs/data_vault_architecture.md`, `docs/star_schema_architecture.md`, `docs/source_to_data_vault.md`.

## Estructura del repositorio

```
models/
  01_staging/tpch/          # Staging TPCH + sources YAML
  02_raw_vault/             # Hubs, links, satellites + tests YAML
  03_business_vault/        # as_of_date, pit_*, bv_* (core + PITs)
  04_marts/core/            # dim_*, fct_* + _marts_models.yml
macros/                     # generate_database_name, generate_schema_name
tests/                      # Assertions SQL adicionales (calidad / coherencia)
docs/                       # Arquitectura y diagramas
dbt_project.yml            # Nombre del proyecto, materializaciones y DB/schema por capa
packages.yml               # Paquetes dbt (automate_dv, dbt_utils)
```

## Bases de datos y esquemas (objetivo)

Configuración en `dbt_project.yml` (los macros de nombre usan los valores personalizados tal cual):

| Capa | Base de datos | Esquema | Materialización principal |
|------|-----------------|---------|---------------------------|
| Staging | `DATA_VAULT` | `STAGING` | tabla |
| Raw Vault | `DATA_VAULT` | `RAW_VAULT` | incremental (append) |
| Business Vault | `DATA_VAULT` | `BUSINESS_VAULT` | tabla |
| Marts | `ANALYTICS` | `MARTS` | tabla |

Ajusta nombres de base de datos o permisos en Snowflake según tu entorno antes de ejecutar `dbt run`.

## Convenciones (resumen)

- **Técnicas en staging**: `LOAD_DATETIME`, `RECORD_SOURCE` (y convenciones de automate_dv en modelos DV).
- **Claves DV**: `*_HK` (hash keys en hubs/links), `*_HASHDIFF` en satélites donde corresponda.
- **Marts**: dimensiones de **estado actual**; hechos alineados con el grano de negocio documentado en YAML bajo `models/04_marts/`.

## Calidad y pruebas

- Tests declarativos en los `_*.yml` bajo cada capa (por ejemplo `models/01_staging/tpch/_tpch__models.yml`, `models/02_raw_vault/_raw_vault_models.yml`, `models/03_business_vault/_business_vault_models.yml`, `models/04_marts/_marts_models.yml`).
- Comprobaciones adicionales en SQL en `tests/` (aserciones de coherencia entre capas).

## Ejecución

1. Configura un perfil dbt (por ejemplo `profiles.yml`) con el target `default` apuntando a Snowflake.
2. Instala dependencias del proyecto:

```bash
dbt deps
```

3. Compila (recomendado antes de `run`):

```bash
dbt compile
```

4. Ejecuta modelos y tests:

```bash
dbt run
dbt test
```

Para ejecutar solo una capa, usa selectores de dbt (por ejemplo `dbt run --select 04_marts` o etiquetas si las añades en el futuro).
