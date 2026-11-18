
{{ config(materialized='table') }}

select
    t.ticket_id,
    t.customer_id,
    t.created_at,
    cast(t.created_at as date) as created_date,
    t.issue_category,
    t.channel,
    t.priority,
    t.assigned_agent_id,

    tm.agent_first_response_at,
    tm.first_response_hours,

    tm.resolved_at,
    tm.resolution_hours,

    tm.first_resolved_at,
    tm.last_resolved_at,
    tm.last_resolution_hours,
    tm.reopened_flag,
    tm.reopen_count,

    ra.resolution_actor_type,

    case
        when ra.resolution_actor_type = 'agent'
             and tm.agent_first_response_at is null
        then true
        else false
    end as missing_agent_response_flag

from {{ ref('stg_tickets') }} as t

left join {{ ref('int_ticket_metrics') }} as tm
    on t.ticket_id = tm.ticket_id

left join {{ ref('int_ticket_resolution_actor') }} as ra
    on t.ticket_id = ra.ticket_id
