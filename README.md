# GameHub synthetic raw exports

All records are fictional, generated deterministically for an Analytics Engineering learning portfolio. Not affiliated with Eneba or any real marketplace.

## Tables and grain
- customers.csv: one row per customer
- products.csv: one row per product
- orders.csv: one row per order
- order_items.csv: one row per order line item
- agents.csv: one row per support agent
- tickets.csv: one row per support ticket; customer_id is present, order_id intentionally absent
- ticket_events.csv: one row per event occurrence, subject to raw export quality issues
- bot_sessions.csv: one row per bot session
- customer_feedback.csv: one row per feedback response

## Intended engineering challenges
- Identify and remove exact duplicate events and handle conflicting duplicate event IDs
- Handle missing ticket issue categories
- Detect an orphan event referencing a nonexistent ticket
- Use event timestamps for business chronology; ingested_at for arrival order and incremental logic
- Calculate reopen counts, first response, resolution durations and status history
- Investigate customer/order proximity without claiming inferred order matches are confirmed
- Avoid fanout when joining order items or events to ticket-level facts
- Define bot deflection carefully; bot resolution is not proof that a customer never contacted support again
- Use ticket created_at and event_timestamp for time-based reporting; do not confuse them with ingestion time

## Design note
A ticket is not linked to a specific order in the source. Some issues (e.g. account access) do not concern an order. Any inferred association must be flagged with confidence and should not be treated as a ground-truth foreign key.

## Getting started
Inspect the CSVs and propose source relationships and quality tests before writing dbt staging models. Do not modify raw exports; clean in staging.
