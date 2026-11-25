{{ config(
    materialized='incremental',
    unique_key='ticket_id',
    incremental_strategy='delete+insert'
) }}

with event_ingestion as (

    select
        ticket_id,
        max(pipeline_ingested_at) as latest_event_ingested_at

    from {{ ref('stg_ticket_events') }}

    group by ticket_id

),

tickets_to_process as (

    select
        t.*,
        ei.latest_event_ingested_at

    from {{ ref('stg_tickets') }} as t

    left join event_ingestion as ei
        on t.ticket_id = ei.ticket_id

    {% if is_incremental() %}

        left join {{ this }} as ft
            on t.ticket_id = ft.ticket_id

        where
            ft.ticket_id is null
            or t.ingested_at is distinct from ft.ticket_ingested_at
            or ei.latest_event_ingested_at is distinct from ft.latest_event_ingested_at

    {% endif %}

)

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
    end as missing_agent_response_flag,

    t.ingested_at as ticket_ingested_at,
    t.latest_event_ingested_at

from tickets_to_process as t

left join {{ ref('int_ticket_metrics') }} as tm
    on t.ticket_id = tm.ticket_id

left join {{ ref('int_ticket_resolution_actor') }} as ra
    on t.ticket_id = ra.ticket_id