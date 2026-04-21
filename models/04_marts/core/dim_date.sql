with date_spine as (
    {{ dbt_utils.date_spine(
        start_date = "'1990-01-01'",
        end_date   = "'2030-12-31'",
        datepart   = 'day'
    ) }}
)

select
    cast(date_day as date)          as date_id,
    extract(year    from date_day)  as year,
    extract(quarter from date_day)  as quarter,
    extract(month   from date_day)  as month,
    extract(week    from date_day)  as week,
    extract(day     from date_day)  as day,
    dayname(date_day)               as day_name,
    monthname(date_day)             as month_name,
    case
        when dayname(date_day) in ('Sat', 'Sun') then true
        else false
    end                             as is_weekend
from date_spine
