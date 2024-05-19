{{
  config(
    materialized = 'table',
    alias='wta'
    )
}}

select * from {{ ref('refined_wta') }}