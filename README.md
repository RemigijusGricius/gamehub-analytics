## Incremental Ticket Processing

The `fct_tickets` model uses dbt incremental materialization with a `delete+insert` strategy and `ticket_id` as the unique key.

### Implementation

- Detects new and updated tickets using pipeline ingestion timestamps.
- Detects changes in dependent ticket event data.
- Supports late-arriving events independently of their original event timestamps.
- Uses Silver-layer deduplication to select the latest version of each ticket and event.
- Supports both incremental execution and full-refresh rebuilding.

### Validation

The implementation was validated locally using six scenarios:

- New ticket insertion.
- Existing ticket updates.
- New events associated with existing tickets.
- Late-arriving historical events.
- Idempotency through repeated pipeline execution.
- Incremental and full-refresh output equivalence.

A chronological data quality test was also added to identify invalid ticket lifecycle timestamps.

### Current Limitations

- Full CSV snapshots are retained in Bronze for historical traceability.
- New snapshot deliveries can trigger reprocessing of unchanged records.
- Source record deletions and certain event reassignment scenarios are not currently supported.

Future improvements may include row-level content hashing and more granular change detection.