WITH ch AS (
    SELECT *
    FROM {{ ref('dim_customers_history') }}
    WHERE valid_to IS NULL
)

SELECT
    COALESCE(c.customer_id, ch.customer_id) AS customer_id,
    c.country AS current_country,
    ch.country AS historical_country
FROM {{ ref('dim_customers') }} AS c
FULL OUTER JOIN ch
    ON ch.customer_id = c.customer_id
WHERE c.customer_id IS NULL
    OR ch.customer_id IS NULL
    OR ch.country IS DISTINCT FROM c.country