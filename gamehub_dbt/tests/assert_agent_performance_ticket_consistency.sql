SELECT *
FROM {{ ref('mart_agent_performance') }}
WHERE resolved_tickets > total_tickets