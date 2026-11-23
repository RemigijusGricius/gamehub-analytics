
{{ config(materialized='table') }}


SELECT assigned_agent_id,
COUNT (ticket_id) AS total_tickets,

SUM (CASE
		WHEN resolved_at IS NOT NULL THEN 1 ELSE 0
END
) AS resolved_tickets,

{{ calculate_rate('resolved_at IS NOT NULL') }} AS resolution_rate_pct,


ROUND (AVG (first_response_hours),2) AS avg_first_response_hours,
ROUND (AVG (resolution_hours),2) AS avg_resolution_hours

FROM {{ ref('fct_tickets') }}
WHERE  assigned_agent_id IS NOT NULL
GROUP BY assigned_agent_id