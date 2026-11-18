
{{ config(materialized='table') }}

SELECT
    te.event_id,
    te.ticket_id,
    te.event_timestamp,
    te.event_type
FROM {{ ref('stg_ticket_events') }} AS te
LEFT JOIN {{ ref('stg_tickets') }} AS t
    ON te.ticket_id = t.ticket_id
WHERE t.ticket_id IS NULL