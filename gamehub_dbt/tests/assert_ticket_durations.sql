SELECT ticket_id,
created_at,
resolved_at,
first_response_hours,
resolution_hours
FROM {{ ref('fct_tickets') }}
WHERE first_response_hours < 0
OR resolution_hours < 0
OR (resolved_at < created_at)