{{
  config(
    materialized = 'table',
    )
}}

select * from {{ ref('rankings_men') }}