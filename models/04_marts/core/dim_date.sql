-- Dimension: Date
-- Generates a standard date dimension using dbt_utils.date_spine

with date_spine as (
    {{ dbt_utils.date_spine(
        start_date = "'1990-01-01'",
        end_date = "'2030-12-31'",
        datepart = 'day'
    ) }}
)

select
    cast(date_day as date) as date_id,
    extract(year from date_day) as year,
    extract(month from date_day) as month,
    extract(day from date_day) as day,
    extract(quarter from date_day) as quarter,
    extract(week from date_day) as week,
    to_char(date_day, 'Day') as day_name,
    to_char(date_day, 'Month') as month_name
from date_spine
