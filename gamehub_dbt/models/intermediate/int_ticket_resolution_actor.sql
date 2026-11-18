
{{ config(materialized='view') }}

with ranked_resolutions as (

    select
        e.ticket_id,
        e.actor_type,
        e.event_timestamp,

        row_number() over (
            partition by e.ticket_id
            order by e.event_timestamp desc, e.event_id desc
        ) as rn

    from {{ ref('stg_ticket_events') }} as e

    inner join {{ ref('stg_tickets') }} as t
        on e.ticket_id = t.ticket_id

    where e.event_type = 'resolved'

)

select
    ticket_id,
    actor_type as resolution_actor_type

from ranked_resolutions
where rn = 1
