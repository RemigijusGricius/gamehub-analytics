
{{ config(materialized='view') }}

select
    ticket_id,
    created_at,
    agent_first_response_at,
    resolved_at,

    first_resolved_at,
    last_resolved_at,
    reopened_flag,
    reopen_count,

    round(
        date_diff('minute', created_at, agent_first_response_at) / 60.0,
        2
    ) as first_response_hours,

    round(
        date_diff('minute', created_at, resolved_at) / 60.0,
        2
    ) as resolution_hours,

    round(
        date_diff('minute', created_at, last_resolved_at) / 60.0,
        2
    ) as last_resolution_hours

from {{ ref('int_ticket_lifecycle') }}
