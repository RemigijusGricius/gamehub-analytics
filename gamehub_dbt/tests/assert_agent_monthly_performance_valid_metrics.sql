SELECT *
FROM {{ ref('mart_agent_monthly_performance') }}
WHERE
    -- Ticket count validation
    total_tickets <= 0
    OR resolved_tickets < 0
    OR resolved_tickets > total_tickets
    OR unresolved_tickets < 0
    OR unresolved_tickets > total_tickets

    -- Resolution rate validation
    OR resolution_rate_pct < 0
    OR resolution_rate_pct > 100

    -- Duration validation
    OR avg_first_response_hours < 0
    OR avg_resolution_hours < 0

    -- Observation count validation
    OR first_response_count < 0
    OR first_response_count > total_tickets
    OR resolution_time_count < 0
    OR resolution_time_count > total_tickets

    -- Ticket count consistency
    OR resolved_tickets + unresolved_tickets <> total_tickets

    -- First response consistency
    OR (first_response_count = 0 AND avg_first_response_hours IS NOT NULL)
    OR (first_response_count > 0 AND avg_first_response_hours IS NULL)

    -- Resolution time consistency
    OR (resolution_time_count = 0 AND avg_resolution_hours IS NOT NULL)
    OR (resolution_time_count > 0 AND avg_resolution_hours IS NULL)

    -- Resolution rate consistency
    OR resolution_rate_pct <> ROUND(
        resolved_tickets * 100.0 / NULLIF(total_tickets, 0),
        2
    )