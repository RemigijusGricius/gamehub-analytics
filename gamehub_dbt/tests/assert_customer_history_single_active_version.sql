SELECT
    customer_id,
    COUNT(*) FILTER (
        WHERE valid_to IS NULL
    ) AS active_versions
FROM {{ ref('dim_customers_history') }}
GROUP BY customer_id
HAVING COUNT(*) FILTER (
    WHERE valid_to IS NULL
) <> 1