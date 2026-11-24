
{{ config(materialized='table') }}



SELECT
    CAST (DATE_TRUNC('month', created_at)AS DATE) AS performance_month,
    ft.assigned_agent_id AS assigned_agent_id,
    COUNT(ft.ticket_id) AS total_tickets,
    COUNT (ft.resolved_at ) AS resolved_tickets,
    COUNT(ft.ticket_id) - COUNT (ft.resolved_at ) AS unresolved_tickets,
    AVG(ft.resolution_hours) AS avg_resolution_hours,
    AVG (ft.first_response_hours) AS avg_first_response_hours,
    ROUND(
    COUNT(ft.resolved_at) * 100.0
    / NULLIF(COUNT(ft.ticket_id), 0),
    2
) AS resolution_rate_pct,
	COUNT(ft.first_response_hours) AS first_response_count,
	COUNT (ft.resolution_hours) AS resolution_time_count
FROM {{ ref('fct_tickets') }} AS ft
WHERE ft.assigned_agent_id IS NOT NULL AND ft.created_at  IS NOT NULL
GROUP BY performance_month, assigned_agent_id
ORDER BY performance_month, assigned_agent_id