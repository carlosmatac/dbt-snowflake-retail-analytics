{% test is_positive(model, column_name) %}

    -- Si este select devuelve algo, el test falla.
    -- Buscamos valores que sean menores que 0.
    select *
    from {{ model }}
    where {{ column_name }} < 0

{% endtest %}