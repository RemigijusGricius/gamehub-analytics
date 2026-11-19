SELECT *
FROM {{ ref('mart_support_kpis') }}
WHERE ABS(
    agent_resolution_rate + bot_resolution_rate - 100
) > 0.01