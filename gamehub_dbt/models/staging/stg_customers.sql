select
    trim(customer_id) as customer_id,
    cast(signup_at as timestamp) as signup_at,
    upper(trim(country)) as country,
    lower(trim(acquisition_channel)) as acquisition_channel,
    source_file,
    file_hash,
    ingested_at
from {{ source('bronze', 'customers') }}