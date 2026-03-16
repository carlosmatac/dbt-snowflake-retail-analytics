{% test not_null(model, column_name) %}

    select *
    from {{ model }}
    where {{ column_name }} is null 
       or cast({{ column_name }} as varchar) = ''  -- NUESTRA LÓGICA PERSONALIZADA

{% endtest %}