select
    trim(ticket_id) as ticket_id,
    trim(customer_id) as customer_id,
    cast(created_at as timestamp) as created_at,
    lower(trim(issue_category)) as issue_category,
    lower(trim(channel)) as channel,
    lower(trim(priority)) as priority,
    nullif(trim(assigned_agent_id), '') as assigned_agent_id,

    -- Ingestion metadata
    source_system,
    source_file,
    file_hash,
    ingested_at

from {{ source('bronze', 'tickets') }}