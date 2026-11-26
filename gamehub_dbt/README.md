Welcome to your new dbt project!

### Using the starter project

Try running the following commands:
- dbt run
- dbt test


### Resources:
- Learn more about dbt [in the docs](https://docs.getdbt.com/docs/introduction)
- Check out [Discourse](https://discourse.getdbt.com/) for commonly asked questions and answers
- Join the [chat](https://community.getdbt.com/) on Slack for live discussions and support
- Find [dbt events](https://events.getdbt.com) near you
- Check out [the blog](https://blog.getdbt.com/) for the latest news on dbt's development and best practices

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
