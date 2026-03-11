# 🛒 Retail Insights - dbt Snowflake Project

Este proyecto utiliza **dbt Core / Cloud** para transformar datos brutos de ventas en un modelo analítico listo para ser consumido por herramientas de BI.

## 🏗️ Arquitectura
* **Data Warehouse:** Snowflake
* **Dataset Crudo:** `SNOWFLAKE_SAMPLE_DATA.TPCH_SF1`
* **Orquestación y Transformación:** dbt

## 📂 Estructura del Proyecto
El proyecto sigue las mejores prácticas de modularidad de dbt:
1. **Staging (`models/staging/`):** Vistas 1:1 con las fuentes originales, dedicadas a la limpieza de nombres, casteo de tipos de datos y estandarización.
2. **Marts (`models/marts/`):** Modelos de negocio donde se cruzan las entidades (Joins) y se aplican agregaciones para el usuario final.

## 🚀 Cómo empezar (Desarrollo local)
1. Asegúrate de tener configurado tu `profiles.yml` apuntando a tu base de datos de desarrollo en Snowflake.
2. Ejecuta `dbt deps` para instalar dependencias (si aplica).
3. Ejecuta `dbt build` para correr modelos y tests.