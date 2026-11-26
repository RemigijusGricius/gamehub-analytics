with cleaned as (

select
    trim(customer_id) as customer_id,
    cast(signup_at as timestamp) as signup_at,
    upper(trim(country)) as country,
    lower(trim(acquisition_channel)) as acquisition_channel,
    source_file,
    file_hash,
    ingested_at
from {{ source('bronze', 'customers') }}
)

select *
from cleaned
qualify row_number() over (
    partition by customer_id
    order by ingested_at desc nulls last,
             file_hash desc
) = 1