{{ config(materialized='table') }}

SELECT
    dbt_scd_id AS customer_version_id,
    customer_id,
    signup_at,
    country,
    acquisition_channel,
    dbt_valid_from AS valid_from,
    dbt_valid_to AS valid_to,
    dbt_valid_to IS NULL AS is_current
FROM {{ ref('snap_customers') }}