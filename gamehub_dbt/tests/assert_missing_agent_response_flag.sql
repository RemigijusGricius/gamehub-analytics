
SELECT
    ticket_id,
    resolution_actor_type,
    agent_first_response_at,
    missing_agent_response_flag

FROM {{ ref('fct_tickets') }}

WHERE missing_agent_response_flag IS DISTINCT FROM (
    COALESCE(resolution_actor_type = 'agent', FALSE)
    AND agent_first_response_at IS NULL
)
