
SELECT *
FROM {{ ref('mart_support_kpis') }}
WHERE resolution_rate < 0
   OR resolution_rate > 100
   OR resolved_within_24h < 0
   OR resolved_within_24h > 100
   OR avg_first_response_hours < 0
   OR avg_resolution_hours < 0
