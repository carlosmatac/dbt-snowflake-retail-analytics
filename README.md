# 🧱 dbt Snowflake Retail Analytics (TPCH) — Data Vault + Star Schema

Proyecto dbt sobre Snowflake usando el dataset de ejemplo **TPCH** (`SNOWFLAKE_SAMPLE_DATA.TPCH_SF1`).

El modelado se implementa en 2 pasos:
1. **Data Vault (Raw Vault)** para historificación y trazabilidad.
2. **Star Schema (Marts)** como capa de consumo (pendiente / en progreso).

## 🏗️ Stack

- Warehouse: **Snowflake**
- Dataset: `SNOWFLAKE_SAMPLE_DATA.TPCH_SF1`
- Framework: **dbt**
- Librería Data Vault: **Datavault-UK/automate_dv**

## � Estructura del repo

La estructura real del proyecto está organizada por capas (ver `dbt_project.yml`):

- `models/01_staging/`
	- Staging 1:1 desde fuentes (normalización, derived columns, hashed columns).
	- Implementado con `automate_dv.stage()`.

- `models/02_raw_vault/`
	- Raw Vault con **Hubs**, **Links** y **Satellites**.
	- Implementado con `automate_dv.hub()`, `automate_dv.link()`, `automate_dv.sat()`.

- `models/04_marts/` (planificado)
	- Modelo estrella (dims/facts) para consumo analítico.

## ✅ Convenciones (resumen)

- Columnas técnicas en staging:
	- `LOAD_DATETIME`: timestamp de carga.
	- `RECORD_SOURCE`: identificador del origen.
- Claves:
	- `*_HK`: hash key (hub/link).
	- `*_HASHDIFF`: hashdiff para satélites.

## 🚀 Ejecución (local / CI)

1. Configura tu conexión en `profiles.yml` apuntando a Snowflake.
2. Instala dependencias:

```powershell
dbt deps
```

3. Compila (recomendado):

```powershell
dbt compile
```

4. Ejecuta modelos y tests:

```powershell
dbt run
dbt test
```

## 🔎 Calidad de datos

- Tests de staging: `models/01_staging/tpch/_tpch__models.yml`
- Tests/documentación del raw vault: `models/02_raw_vault/_raw_vault_models.yml`