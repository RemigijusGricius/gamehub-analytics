
{{ config(materialized='table') }}

SELECT
    priority,

    COUNT(ticket_id) AS total_tickets,

    COUNT(
        CASE
            WHEN resolved_at IS NOT NULL THEN 1
        END
    ) AS resolved_tickets,

    {{ calculate_rate('resolved_at IS NOT NULL') }} AS resolution_rate,

    ROUND(AVG(first_response_hours), 2)
        AS avg_first_response_hours,

    ROUND(AVG(resolution_hours), 2)
        AS avg_first_resolution_hours,

    ROUND(AVG(last_resolution_hours), 2)
        AS avg_last_resolution_hours,

    COUNT(CASE WHEN resolution_actor_type = 'bot' THEN 1 END) AS bot_resolved_tickets,

    COUNT(CASE WHEN reopened_flag = TRUE THEN 1 END) AS reopened_tickets,

    {{ calculate_rate('reopened_flag = TRUE') }} AS reopening_rate

FROM {{ ref('fct_tickets') }}
GROUP BY priority
