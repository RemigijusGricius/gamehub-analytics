{{ config(materialized='view') }}

with cleaned as (

    select
        trim(ticket_id) as ticket_id,
        trim(customer_id) as customer_id,
        cast(created_at as timestamp) as created_at,
        lower(trim(issue_category)) as issue_category,
        lower(trim(channel)) as channel,
        lower(trim(priority)) as priority,
        nullif(trim(assigned_agent_id), '') as assigned_agent_id,

        source_system,
        source_file,
        file_hash,
        ingested_at

    from {{ source('bronze', 'tickets') }}

)

select *
from cleaned

qualify row_number() over (
    partition by ticket_id
    order by ingested_at desc nulls last,
             file_hash desc
) = 1