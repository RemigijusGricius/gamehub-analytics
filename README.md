# GameHub — Customer Support Analytics Platform


[![CI](https://github.com/RemigijusGricius/gamehub-analytics/actions/workflows/ci.yml/badge.svg)](https://github.com/RemigijusGricius/gamehub-analytics/actions/workflows/ci.yml)


**An end-to-end Analytics Engineering portfolio project using Python, DuckDB, dbt Core, SQL, and GitHub Actions.**

GameHub is a fictional digital marketplace used to demonstrate how raw operational data can be transformed into reliable, tested, analytics-ready datasets.

The project covers data ingestion, dimensional modeling, customer support lifecycle analysis, data quality validation, automated testing, and CI/CD.

All records are synthetic and generated for educational and demonstration purposes. GameHub does not represent a real company or production system.

## 1. Project Overview

Customer support data often comes from multiple operational systems, including ticketing platforms, customer databases, automated support tools, and transaction systems.

These sources can contain duplicate records, missing values, inconsistent event histories, and relationships that are difficult to establish reliably.

The goal of GameHub is to build a reproducible analytics platform that transforms such data into trusted reporting datasets.

**Key objectives:**

- Ingest raw CSV exports into DuckDB.
- Implement a layered Bronze → Silver → Gold architecture.
- Build reusable transformations using dbt Core.
- Calculate ticket lifecycle and customer support performance metrics.
- Detect and monitor data quality issues.
- Validate transformations through automated tests.
- Automate pipeline execution using GitHub Actions.
- Publish analytics-ready datasets in Parquet format.

## 2. Technology Stack

| Technology | Purpose |
|---|---|
| Python | Data ingestion, file validation, and exports |
| DuckDB | Local analytical database |
| SQL | Data transformation and business logic |
| dbt Core | Data modeling, testing, and transformation orchestration |
| Git & GitHub | Version control and source code management |
| GitHub Actions | Continuous Integration and automated artifact publishing |
| Parquet | Columnar format for analytical data exports |
| DBeaver | Database exploration and SQL validation |
| VS Code | Development environment |

The project uses DuckDB as an embedded analytical database, allowing the pipeline to run without requiring a separately hosted database server.

## 3. Data Architecture

The project follows a layered data architecture.

```text
Synthetic CSV Exports
         |
         v
+---------------------------+
| BRONZE                    |
| Raw source ingestion      |
| File tracking             |
| SHA-256 deduplication     |
+---------------------------+
         |
         v
+---------------------------+
| SILVER                    |
| dbt staging models        |
| Intermediate models       |
| Cleaning and lifecycle    |
| transformations           |
+---------------------------+
         |
         v
+---------------------------+
| GOLD                      |
| Customer dimension        |
| Ticket fact table         |
| Support KPI marts         |
| Data quality monitoring   |
+---------------------------+
         |
         v
+---------------------------+
| PARQUET EXPORTS           |
| Automated artifact        |
| publishing via GitHub     |
| Actions                   |
+---------------------------+
```

### Bronze — Raw Data Ingestion

Python loads source CSV files into DuckDB's `bronze` schema.

The ingestion process includes:

- Source file discovery.
- SHA-256 file hashing.
- File-level ingestion logging.
- Detection of previously processed file versions.
- Transactional ingestion.
- Rollback when an ingestion operation fails.

The ingestion process is designed to avoid unnecessarily reprocessing unchanged source files.

**Main script:** `scripts/ingest_bronze.py`

### Silver — Data Cleaning and Transformation

The Silver layer is implemented using dbt staging and intermediate models.

Staging models standardize and prepare source data.

Intermediate models implement reusable business logic, including ticket lifecycle reconstruction, customer relationships, response timing, and resolution attribution.

### Gold — Analytics-Ready Data

The Gold layer contains dimensional models and aggregated reporting tables.

These datasets support customer support performance analysis and can be consumed by downstream reporting tools.

## 4. Source Data

The project uses nine synthetic CSV datasets.

| Source | Grain |
|---|---|
| `customers.csv` | One row per customer |
| `products.csv` | One row per product |
| `orders.csv` | One row per order |
| `order_items.csv` | One row per order line item |
| `agents.csv` | One row per support agent |
| `tickets.csv` | One row per support ticket |
| `ticket_events.csv` | One row per ticket event occurrence |
| `bot_sessions.csv` | One row per bot session |
| `customer_feedback.csv` | One row per feedback response |

The synthetic data includes intentional quality issues to demonstrate validation and monitoring techniques.

## 5. Data Models

### Staging Models

- `stg_customers`
- `stg_tickets`
- `stg_ticket_events`

These models prepare the raw source records for downstream transformations.

### Intermediate Models

- `int_tickets_customers`
- `int_ticket_lifecycle`
- `int_ticket_metrics`
- `int_ticket_resolution_actor`

These models organize reusable business logic and reduce duplication across downstream reporting tables.

### Gold Models

| Model | Purpose |
|---|---|
| `dim_customers` | Customer dimension |
| `fct_tickets` | Ticket-level analytical fact table |
| `mart_support_kpis` | Overall customer support KPIs |
| `mart_support_by_channel` | Performance by support channel |
| `mart_support_by_issue_category` | Performance by issue category |
| `mart_support_by_priority` | Performance by ticket priority |
| `dq_orphan_ticket_events` | Monitoring of events referencing nonexistent tickets |

The ticket fact table serves as the primary source for aggregated support performance reporting.

## 6. Customer Support Metrics

The platform calculates metrics including:

- Total support tickets.
- Resolved and unresolved tickets.
- Resolution rate.
- First response time.
- First and latest recorded resolution durations.
- Ticket reopening rate.
- Bot-resolved and agent-resolved tickets.
- Missing agent response indicators.
- Performance by channel, issue category, and priority.

### Example Results

The following figures come from the synthetic GameHub dataset.

| Metric | Result |
|---|---:|
| Total tickets | 1,800 |
| Resolved tickets | 1,624 |
| Unresolved tickets | 176 |
| Resolution rate | 90.22% |
| Reopened tickets | 222 |
| Reopening rate | 12.33% |
| Bot-resolved tickets | 225 |
| Agent-resolved tickets | 1,399 |
| Average first response time | 5.15 hours |
| Average first resolution time | 51.42 hours |
| Average latest recorded resolution duration | 60.33 hours |

These figures are illustrative and do not represent actual marketplace performance.

## 7. Data Quality and Testing

Data quality is a core part of the project.

The pipeline addresses several common analytical engineering challenges.

### Duplicate Events

Source events may contain exact duplicates or conflicting records with the same event identifier.

The transformation logic handles these conditions to avoid incorrect event counts and ticket lifecycle calculations.

### Orphan Records

The synthetic dataset deliberately includes a ticket event referencing a nonexistent ticket.

A dbt relationship test identifies this issue, and the `dq_orphan_ticket_events` model makes it available for monitoring.

The relationship test is configured to produce a warning rather than fail the entire build.

### Missing Values

The transformations account for missing fields, including ticket issue categories and incomplete response histories.

### Event Chronology

Ticket lifecycle calculations use business event timestamps rather than assuming ingestion order represents the actual sequence of customer support activity.

### Join Fanout

Ticket-level metrics are designed to avoid unintended row multiplication when joining one-to-many datasets.

### Automated dbt Tests

The project includes:

- `not_null` tests.
- `unique` tests.
- `relationships` tests.
- `accepted_values` tests.
- Custom singular SQL tests.
- KPI range validation.
- Reconciliation between aggregated marts and ticket-level data.

A reusable dbt macro supports consistent rate calculations across reporting models.

**Latest validated build:**

```text
PASS=63
WARN=1
ERROR=0
SKIP=0
TOTAL=64
```

The single warning is expected and relates to the deliberately introduced orphan event.

## 8. CI/CD — GitHub Actions

GitHub Actions automatically validates the analytics pipeline.

The workflow is defined in:

`.github/workflows/ci.yml`

### Workflow Triggers

The pipeline runs when:

- Code is pushed to `main`.
- A pull request targeting `main` is opened or updated.

### Continuous Integration

The CI process performs the following operations:

1. Checks out the repository.
2. Configures Python.
3. Installs pinned dependencies.
4. Ingests source data into DuckDB.
5. Verifies that the Bronze ticket table is available.
6. Configures the dbt connection.
7. Builds dbt models and executes data quality tests.

### Automated Artifact Publishing

After a successful CI run on `main`, the workflow:

1. Exports six Gold tables to Parquet.
2. Publishes the files as a GitHub Actions artifact.
3. Makes the artifact available for download from the workflow run.

**Artifact name:** `gamehub-gold-tables`

**Retention:** 30 days

This demonstrates automated delivery of validated analytical datasets.

The project does not currently deploy to a persistent production database. Published artifacts are generated within GitHub Actions and retained according to the workflow configuration.

## 9. Repository Structure

```text
gamehub-analytics/
|
|-- .github/
|   `-- workflows/
|       `-- ci.yml
|
|-- data/
|   |-- raw/
|   `-- exports/              # Generated locally; Git-ignored
|
|-- scripts/
|   |-- ingest_bronze.py
|   `-- export_gold.py
|
|-- gamehub_dbt/
|   |-- models/
|   |   |-- staging/
|   |   |-- intermediate/
|   |   `-- marts/
|   |-- macros/
|   |-- tests/
|   |-- dbt_project.yml
|   `-- profiles.ci.yml
|
|-- sql/
|   `-- validation/
|
|-- requirements.txt
|-- .gitignore
`-- README.md
```

## 10. Running the Project Locally

### Prerequisites

- Python 3.12
- Git
- VS Code or another development environment

### Step 1 — Clone the Repository

```bash
git clone https://github.com/RemigijusGricius/gamehub-analytics.git
cd gamehub-analytics
```

### Step 2 — Create a Virtual Environment

```bash
python -m venv .venv
```

Activate it on Windows PowerShell:

```powershell
.\.venv\Scripts\Activate.ps1
```

### Step 3 — Install Dependencies

```bash
python -m pip install -r requirements.txt
```

### Step 4 — Ingest Source Data

```bash
python scripts/ingest_bronze.py
```

This creates the DuckDB database and loads the raw source datasets.

### Step 5 — Configure dbt

The repository includes a CI profile template:

`gamehub_dbt/profiles.ci.yml`

For a local run, create a `profiles.yml` file in the `gamehub_dbt` directory with a database path pointing to your local project.

Example:

```yaml
gamehub_dbt:
  target: dev
  outputs:
    dev:
      type: duckdb
      path: "C:/path/to/gamehub-analytics/gamehub.duckdb"
      schema: main
      threads: 1
```

Replace the example path with the actual absolute path on your computer.

### Step 6 — Build and Test dbt Models

```bash
dbt build --project-dir gamehub_dbt --profiles-dir gamehub_dbt
```

This executes the transformations and automated data quality tests.

### Step 7 — Export Gold Tables

```bash
python scripts/export_gold.py
```

The exported Parquet files will be created in:

`data/exports/`

**Note:** DuckDB may prevent simultaneous access from multiple processes. Disconnect DBeaver or other applications holding a write connection to the database before running ingestion, dbt, or export scripts.

## 11. Important Data Modeling Assumptions

### Ticket-to-Order Relationships

Support tickets contain customer identifiers but do not have a confirmed foreign key to individual orders.

Some support issues, such as account access, may not relate to a specific order.

Therefore, any ticket-to-order association inferred through timing or customer activity should be treated as an estimate, not a confirmed relationship.

### Bot Resolution and Deflection

A ticket resolved by a bot does not necessarily mean the customer avoided all subsequent human support interactions.

Bot resolution and bot deflection are different concepts and should not be treated as interchangeable without an explicit business definition.

### First Response and Resolution Timing

Support metrics are derived from recorded ticket events.

Missing or incomplete event histories can affect calculated durations and response indicators.

### Synthetic Data Limitations

The dataset was created to demonstrate engineering methods rather than reproduce a real marketplace's operational patterns.

Business conclusions drawn from the sample data should not be generalized to real-world customer support performance.

## 12. Engineering Practices Demonstrated

This project demonstrates practical experience with:

- Layered analytical data architecture.
- File-based ingestion and source deduplication.
- Transaction handling and rollback.
- SQL transformations and dimensional modeling.
- dbt model dependencies and reusable macros.
- Automated data quality testing.
- Business metric reconciliation.
- Git version control.
- GitHub Actions CI.
- Automated publication of analytical outputs.
- Reproducible local development environments.

## 13. Future Improvements

Potential extensions include:

- Incremental dbt models for larger datasets.
- Additional source integration for orders and customer feedback.
- Automated pipeline monitoring and alerting.
- Feature branch workflows with required pull request checks.
- Deployment to a persistent cloud data platform.
- A BI dashboard connected to the Gold reporting layer.

---

**Project type:** Personal Analytics Engineering portfolio  
**Data:** Fully synthetic  
**Purpose:** Learning, experimentation, and demonstration of engineering practices

## Summary

Implement incremental ticket processing in the Gold layer, including change detection across tickets and dependent ticket events.

## Changes

- Convert `fct_tickets` to incremental materialization using the `delete+insert` strategy.
- Implement ingestion timestamp-based change detection.
- Introduce latest-record deduplication in Silver staging models.
- Support late-arriving events.
- Add a chronological data quality test.
- Add a reusable synthetic test data generator.
- Update README documentation.

## Validation

- [x] New ticket insertion
- [x] Existing ticket updates
- [x] New event processing
- [x] Late-arriving event processing
- [x] Idempotency and output consistency
- [x] Incremental vs. full-refresh equivalence
- [x] Chronological data quality test
- [x] Full-refresh dbt build
- [x] Standard dbt build
- [x] Original dataset restored

## Known Limitations

- Full snapshot deliveries may trigger unnecessary reprocessing of unchanged records.
- Source deletions and certain event reassignment scenarios require additional change detection logic.
- Incremental scenarios were validated manually and are not yet automated in CI/CD.

## Future Improvements

Implement row-level content hashing and automated incremental regression tests.

## Reusable dbt Macros

The project uses reusable Jinja macros to standardize analytical calculations and reduce SQL duplication across Gold-layer models.

| Macro | Purpose |
|---|---|
| `calculate_rate` | Standardizes percentage calculations with configurable denominators, rounding and division-by-zero protection. |
| `calculate_average` | Calculates averages with optional decimal precision. |

### Refactored models

- `mart_support_kpis`
- `mart_agent_monthly_performance`
- `mart_support_by_channel`
- `mart_support_by_issue_category`
- `mart_support_by_priority`

### Validation

- Compared original and refactored model results using bidirectional `EXCEPT ALL`.
- Confirmed zero row differences across all five models.
- Verified column names, data types and column order using `information_schema.columns`.
- Preserved existing metric definitions and downstream reporting compatibility.

The refactoring improves SQL maintainability while preserving existing analytical results. Zero-denominator rate calculations return NULL.

## Reusable Custom Generic Data Tests

Implemented a reusable `valid_range` generic dbt test to standardize column-level data quality validation across analytical models.

### Key capabilities

- Configurable minimum and maximum boundaries.
- Support for minimum-only, maximum-only and two-sided validation.
- Compilation error handling for missing or invalid boundary configurations.
- Independent handling of NULL values through `not_null` tests where required.
- Centralized validation logic configured through model YAML files.

### Implementation

- Applied 19 reusable range test configurations across four analytical models.
- Refactored existing singular tests to focus on business logic and cross-column consistency.
- Removed redundant range and duration validation tests while preserving existing validation rules.
- Improved data quality troubleshooting through column-specific test results.

### Validation

Full dbt build completed successfully:

- Passed: 101
- Warnings: 1
- Errors: 0
- Skipped: 0

## Customer History — dbt Snapshots & SCD Type 2

Implemented historical customer tracking using dbt snapshots and Slowly Changing Dimension Type 2 (SCD2) modeling.

### Implementation

- Enhanced `stg_customers` with deduplication to retain the latest customer record.
- Implemented `snap_customers` using the dbt check strategy.
- Configured `customer_id` as the snapshot unique key.
- Tracked changes to the customer country while excluding ingestion metadata from change detection.
- Created `dim_customers_history` as a business-facing historical dimension.
- Retained `dim_customers` as the current-state customer dimension.
- Implemented validity timestamps, unique customer version identifiers, and current-version indicators.

### Historical Analysis

Validated point-in-time joins using inclusive start and exclusive end timestamps. This enables historical events to be associated with the customer version valid at the event timestamp without duplicating fact records.

Historical tracking begins when the snapshot first captures customer data. Changes represent observed snapshot timestamps rather than necessarily the actual business change timestamps.

### Data Quality

Implemented nine automated data quality tests:

- Five generic tests covering uniqueness and required fields.
- Exactly one active version per customer.
- Valid chronological boundaries.
- No overlapping historical validity periods.
- Reconciliation between current and historical customer dimensions.

### Validation

Manually validated the following scenarios:

- Initial snapshot creation.
- Changes to tracked customer attributes.
- New customer insertion.
- Changes to untracked attributes.
- Repeated snapshot execution without business changes.
- Point-in-time joins and timestamp precision.

Original source data and database state were restored after development experiments.

Full dbt build results:

`PASS=112 WARN=1 ERROR=0 SKIP=0 TOTAL=113`

## dbt Unit Testing

The project implements 15 native dbt unit tests to validate transformation logic using controlled input fixtures and expected outputs.

| Model | Unit tests | Coverage |
|---|---:|---|
| `int_ticket_metrics` | 3 | Duration calculations, NULL handling and rounding |
| `int_tickets_customers` | 3 | Customer enrichment, unmatched records and empty inputs |
| `int_ticket_lifecycle` | 6 | Event aggregation, reopening logic, multiple responses, orphan events and event ordering |
| `fct_tickets` | 3 | Full-refresh behavior, incremental record selection and missing agent response flags |

### Testing approach

- Mock upstream dependencies using `given` and `ref()`.
- Define expected transformation results using `expect`.
- Test incremental and non-incremental execution using macro overrides.
- Mock the existing incremental target table using `this`.
- Validate NULL-safe comparisons and business logic edge cases.

### Running tests

Run all unit tests:

```bash
dbt test --select "test_type:unit"
```

Run all data tests:

```bash
dbt test --select "test_type:data"
```

Run the complete project build, including unit and data tests:

```bash
dbt build
```

### Validation results

- 15 native dbt unit tests passed.
- Full project build: 127 passed, 1 warning, 0 errors.

Incremental unit tests validate the records selected for processing, while integration testing validates the actual incremental materialization behavior.

## Source Freshness Monitoring

The project implements dbt source freshness checks to detect stale
source data before executing downstream transformations.

### Freshness Configuration

Freshness thresholds are defined at the source level and inherited
by individual Bronze tables. Table-level overrides are used where
ingestion metadata column names differ.

| Source Table | Timestamp Column | Warning | Error |
|---|---|---|---|
| bronze.customers | ingested_at | 24 hours | 48 hours |
| bronze.tickets | ingested_at | 24 hours | 48 hours |
| bronze.ticket_events | ingested_at_1 | 24 hours | 48 hours |

Freshness is evaluated using pipeline ingestion timestamps rather
than business event timestamps to support late-arriving data.

### Running Freshness Checks

Check all configured sources:

```bash
dbt source freshness
```

Check an individual source:

```bash
dbt source freshness --select source:bronze.tickets
```

Freshness results are stored in `target/sources.json` and can be
used for monitoring, alerting and orchestration.

### Validation

All three freshness scenarios were successfully validated by
temporarily adjusting freshness thresholds without modifying
the underlying source data.

| Scenario | Expected Result | Validation |
|---|---|---|
| Data within freshness threshold | PASS | Passed |
| Data exceeds warning threshold | WARN | Passed |
| Data exceeds error threshold | ERROR STALE | Passed |

### CI/CD Integration

Source freshness is configured as a quality gate in the GitHub
Actions workflow before dbt model execution.

Pipeline execution sequence:

1. Bronze data ingestion
2. Install dbt dependencies
3. Source freshness checks
4. Prepare incremental model schema
5. Build and test dbt models

Pipeline behavior:

- PASS: Continue pipeline execution.
- WARN: Report warning and continue execution.
- ERROR: Stop execution and prevent downstream transformations.

### Known Limitations

The CI environment creates a fresh DuckDB database and ingests
source files during each execution. Therefore, freshness checks
in CI validate ingestion recency rather than actual upstream
business data recency.

In a production environment, freshness monitoring should operate
against persistent source tables and be complemented by upstream
file delivery monitoring.