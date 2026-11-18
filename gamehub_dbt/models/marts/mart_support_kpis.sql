
{{ config(materialized='table') }}

SELECT
    COUNT(*) as total_tickets,
    ROUND(avg(first_response_hours), 2) as avg_first_response_hours,
    ROUND(avg(resolution_hours), 2) as avg_resolution_hours,
    ROUND(
        COUNT(resolution_hours) * 100.0 / COUNT(*),
        2
    ) AS resolution_rate,
    ROUND (
    	COUNT(CASE WHEN resolution_hours <= 24 THEN 1 END) *100.0 / COUNT(resolution_hours),2
    ) AS resolved_within_24h,
    -- Percentage of resolved tickets handled by a bot
ROUND(
    COUNT(*) FILTER (
        WHERE resolution_actor_type = 'bot'
    ) * 100.0
    / NULLIF(
        COUNT(*) FILTER (
            WHERE resolution_actor_type IS NOT NULL
        ), 0
    ),
    2
) AS bot_resolution_rate,

-- Percentage of tickets reopened at least once
ROUND(
    COUNT(*) FILTER (
        WHERE reopened_flag = TRUE
    ) * 100.0 / NULLIF(COUNT(*), 0),
    2
) AS reopening_rate,

-- Average time to latest recorded resolution
ROUND(
    AVG(last_resolution_hours),
    2
) AS avg_last_resolution_hours,

-- Agent-resolved tickets without recorded first response
ROUND(
    COUNT(*) FILTER (
        WHERE missing_agent_response_flag = TRUE
    ) * 100.0
    / NULLIF(
        COUNT(*) FILTER (
            WHERE resolution_actor_type = 'agent'
        ), 0
    ),
    2
) AS missing_agent_response_rate
FROM {{ ref('fct_tickets')}}


