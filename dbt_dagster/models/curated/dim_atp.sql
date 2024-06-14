{{
  config(
    materialized = 'table',
    )
}}

select * from {{ ref('REF_rankings_men') }}