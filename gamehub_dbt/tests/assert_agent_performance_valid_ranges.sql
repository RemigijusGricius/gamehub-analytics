SELECT *
FROM {{ ref('mart_agent_performance') }}
WHERE resolution_rate_pct < 0
   OR resolution_rate_pct > 100
   OR avg_first_response_hours < 0
   OR avg_resolution_hours < 0
   OR total_tickets <= 0
   OR resolved_tickets < 0
   OR resolved_tickets > total_tickets