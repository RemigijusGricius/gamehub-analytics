{{ config(materialized='table') }}

SELECT
    COUNT(*) AS total_tickets,

    {{ calculate_average('first_response_hours', 2) }}
        AS avg_first_response_hours,

    {{ calculate_average('resolution_hours', 2) }}
        AS avg_resolution_hours,

    {{ calculate_rate('resolution_hours IS NOT NULL') }}
        AS resolution_rate,

    {{ calculate_rate(
        'resolution_hours <= 24',
        'COUNT(resolution_hours)'
    ) }} AS resolved_within_24h,

    -- Percentage of resolved tickets handled by a bot
    {{ calculate_rate(
        "resolution_actor_type = 'bot'",
        "COUNT(*) FILTER (WHERE resolution_actor_type IS NOT NULL)"
    ) }} AS bot_resolution_rate,

    -- Percentage of tickets reopened at least once
    {{ calculate_rate('reopened_flag = TRUE') }}
        AS reopening_rate,

    -- Average time to latest recorded resolution
    {{ calculate_average('last_resolution_hours', 2) }}
        AS avg_last_resolution_hours,

    -- Agent-resolved tickets without recorded first response
    {{ calculate_rate(
        'missing_agent_response_flag = TRUE',
        "COUNT(*) FILTER (WHERE resolution_actor_type = 'agent')"
    ) }} AS missing_agent_response_rate,

    {{ calculate_rate(
        "resolution_actor_type = 'agent'",
        "COUNT(*) FILTER (WHERE resolution_actor_type IS NOT NULL)"
    ) }} AS agent_resolution_rate

FROM {{ ref('fct_tickets') }}