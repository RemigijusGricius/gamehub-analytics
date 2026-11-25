SELECT *
FROM {{ ref('fct_tickets') }}
WHERE agent_first_response_at < created_at
   OR resolved_at < created_at
   OR first_resolved_at < created_at
   OR last_resolved_at < created_at
   OR last_resolved_at < first_resolved_at