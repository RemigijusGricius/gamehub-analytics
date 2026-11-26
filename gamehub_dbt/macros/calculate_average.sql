{% macro calculate_average(column_name, decimals=none) -%}

    {%- if decimals is not none -%}
        ROUND(AVG({{ column_name }}), {{ decimals }})
    {%- else -%}
        AVG({{ column_name }})
    {%- endif -%}

{%- endmacro %}