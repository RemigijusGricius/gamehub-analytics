
{{ config(materialized='table') }}

select
customer_id,
signup_at,
country,
acquisition_channel
from {{ ref('stg_customers') }}
