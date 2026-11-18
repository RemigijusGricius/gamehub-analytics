
select
    t.ticket_id,
    t.customer_id,
    t.created_at,
    t.issue_category,
    t.channel,
    t.priority,
    t.assigned_agent_id,

    c.signup_at as customer_signup_at,
    c.country as customer_country,
    c.acquisition_channel

from {{ ref('stg_tickets') }} as t

left join {{ ref('stg_customers') }} as c
    on t.customer_id = c.customer_id
