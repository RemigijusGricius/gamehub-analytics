WITH customer_versions AS (
    SELECT
        customer_version_id,
        customer_id,
        valid_from,
        valid_to,
        LEAD(valid_from) OVER (
            PARTITION BY customer_id
            ORDER BY valid_from, customer_version_id
        ) AS next_valid_from
    FROM {{ ref('dim_customers_history') }}
)

SELECT *
FROM customer_versions
WHERE next_valid_from IS NOT NULL
    AND (
        valid_to > next_valid_from
        OR valid_to IS NULL
    )