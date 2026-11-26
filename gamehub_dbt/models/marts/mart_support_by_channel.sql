{{ config(materialized='table') }}

SELECT
    channel,
    COUNT(ticket_id) AS total_tickets,

    COUNT(
        CASE
            WHEN resolved_at IS NOT NULL THEN 1
            ELSE NULL
        END
    ) AS resolved_tickets,

    {{ calculate_average('first_response_hours', 2) }}
        AS avg_response_hours,

    {{ calculate_average('resolution_hours', 2) }}
        AS avg_resolution_time,

    {{ calculate_average('last_resolution_hours', 2) }}
        AS avg_last_resolution_hours,

    COUNT(
        CASE
            WHEN resolution_actor_type = 'bot'
                AND resolved_at IS NOT NULL
            THEN 1
            ELSE NULL
        END
    ) AS bot_resolved_tickets,

    COUNT(
        CASE
            WHEN reopened_flag = TRUE THEN 1
            ELSE NULL
        END
    ) AS reopened_tickets

FROM {{ ref('fct_tickets') }}

GROUP BY channel