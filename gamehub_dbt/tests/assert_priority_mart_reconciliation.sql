
WITH fact_totals AS (
    SELECT
        COUNT(*) AS total_tickets,
        COUNT(*) FILTER (
            WHERE resolved_at IS NOT NULL
        ) AS resolved_tickets
    FROM {{ ref('fct_tickets') }}
),

mart_totals AS (
    SELECT
        SUM(total_tickets) AS total_tickets,
        SUM(resolved_tickets) AS resolved_tickets
    FROM {{ ref('mart_support_by_priority') }}
)

SELECT *
FROM fact_totals
CROSS JOIN mart_totals
WHERE fact_totals.total_tickets
        IS DISTINCT FROM mart_totals.total_tickets
   OR fact_totals.resolved_tickets
        IS DISTINCT FROM mart_totals.resolved_tickets
