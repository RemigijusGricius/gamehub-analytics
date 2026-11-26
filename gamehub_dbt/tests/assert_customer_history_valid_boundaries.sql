SELECT
    customer_version_id,
    customer_id,
    valid_from,
    valid_to
FROM {{ ref('dim_customers_history') }}
WHERE valid_to <= valid_from