
WITH monthly AS (

    SELECT
        assigned_agent_id,
        SUM(total_tickets) AS total_tickets,
        SUM(resolved_tickets) AS resolved_tickets,
        SUM(unresolved_tickets) AS unresolved_tickets
    FROM {{ ref('mart_agent_monthly_performance') }}
    GROUP BY assigned_agent_id

),

lifetime AS (

    SELECT
        assigned_agent_id,
        total_tickets,
        resolved_tickets,
        total_tickets - resolved_tickets AS unresolved_tickets
    FROM {{ ref('mart_agent_performance') }}

)

SELECT
    COALESCE(m.assigned_agent_id, l.assigned_agent_id)
        AS assigned_agent_id,

    m.total_tickets AS monthly_total,
    l.total_tickets AS lifetime_total,

    m.resolved_tickets AS monthly_resolved,
    l.resolved_tickets AS lifetime_resolved,

    m.unresolved_tickets AS monthly_unresolved,
    l.unresolved_tickets AS lifetime_unresolved

FROM monthly m
FULL OUTER JOIN lifetime l
    ON m.assigned_agent_id = l.assigned_agent_id

WHERE
    m.assigned_agent_id IS NULL
    OR l.assigned_agent_id IS NULL
    OR m.total_tickets <> l.total_tickets
    OR m.resolved_tickets <> l.resolved_tickets
    OR m.unresolved_tickets <> l.unresolved_tickets