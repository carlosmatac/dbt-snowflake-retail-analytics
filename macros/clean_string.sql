 -- Quita espacios a los lados y lo pone todo en minúsculas
{% macro clean_string(column_name) %}
    
    trim(lower({{ column_name }}))
    
{% endmacro %}