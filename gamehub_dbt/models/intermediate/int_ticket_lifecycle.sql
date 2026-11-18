
{{ config(materialized='view') }}

select
    e.ticket_id,

    min(
        case
            when e.event_type = 'created'
            then e.event_timestamp
        end
    ) as created_at,

    min(
        case
            when e.event_type = 'agent_first_response'
            then e.event_timestamp
        end
    ) as agent_first_response_at,

    -- Existing field retained for downstream compatibility
    min(
        case
            when e.event_type = 'resolved'
            then e.event_timestamp
        end
    ) as resolved_at,

    -- First and latest resolution timestamps
    min(
        case
            when e.event_type = 'resolved'
            then e.event_timestamp
        end
    ) as first_resolved_at,

    max(
        case
            when e.event_type = 'resolved'
            then e.event_timestamp
        end
    ) as last_resolved_at,

    -- Number of times the ticket was reopened
    count(
        case
            when e.event_type = 'reopened'
            then 1
        end
    ) as reopen_count,

    -- Whether the ticket was ever reopened
    case
        when count(
            case
                when e.event_type = 'reopened'
                then 1
            end
        ) > 0
        then true
        else false
    end as reopened_flag

from {{ ref('stg_ticket_events') }} as e

inner join {{ ref('stg_tickets') }} as t
    on e.ticket_id = t.ticket_id

group by e.ticket_id
