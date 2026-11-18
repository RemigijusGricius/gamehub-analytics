
SELECT
    (SELECT COUNT(*) FROM main.fct_tickets) AS fact_total_tickets,

    (SELECT SUM(total_tickets)
     FROM main.mart_support_by_priority) AS mart_total_tickets,

    (SELECT COUNT(*)
     FROM main.fct_tickets
     WHERE resolved_at IS NOT NULL) AS fact_resolved_tickets,

    (SELECT SUM(resolved_tickets)
     FROM main.mart_support_by_priority) AS mart_resolved_tickets;
