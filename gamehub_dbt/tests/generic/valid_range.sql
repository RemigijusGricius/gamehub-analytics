{% test valid_range(model, column_name, min_value=none, max_value=none) -%}

    {% if min_value is none and max_value is none %}
        {{ exceptions.raise_compiler_error("At least one boundary must be provided.") }}
    {% endif %}

    {% if min_value is not none and max_value is not none %}
        {% if min_value > max_value %}
            {{ exceptions.raise_compiler_error("Minimum value cannot exceed maximum value.") }}
        {% endif %}
    {% endif %}

    SELECT *
    FROM {{ model }}
    WHERE 1 = 0

    {% if min_value is not none %}
        OR {{ column_name }} < {{ min_value }}
    {% endif %}

    {% if max_value is not none %}
        OR {{ column_name }} > {{ max_value }}
    {% endif %}

{%- endtest %}