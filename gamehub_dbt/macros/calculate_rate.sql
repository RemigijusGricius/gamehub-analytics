
{% macro calculate_rate(condition, denominator='COUNT(*)') %}

    ROUND(
        COUNT(*) FILTER (WHERE {{ condition }}) * 100.0
        / NULLIF({{ denominator }}, 0),
        2
    )

{% endmacro %}
