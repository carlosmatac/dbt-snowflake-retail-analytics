-- Requisito 3: Materializar como tabla
{{ config(materialized='table') }}

-- Requisito 2: Usar la macro date_spine para el año 2020
-- (Nota: la fecha de fin es exclusiva, por eso ponemos 2021-01-01 para que llegue hasta el 31 de dic)
{{ dbt_utils.date_spine(
    datepart="day",
    start_date="cast('2020-01-01' as date)",
    end_date="cast('2021-01-01' as date)"
) }}