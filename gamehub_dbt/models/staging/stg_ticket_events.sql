
{{ config(materialized='view') }}

select distinct
    trim(event_id) as event_id,
    trim(ticket_id) as ticket_id,
    event_timestamp,
    lower(trim(event_type)) as event_type,
    lower(trim(actor_type)) as actor_type,
    ingested_at as source_ingested_at,
    ingested_at_1 as pipeline_ingested_at,
    source_file,
    file_hash

from {{ source('bronze', 'ticket_events') }}
