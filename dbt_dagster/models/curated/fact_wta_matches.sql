{{
  config(
    materialized = 'table',
    )
}}

select * 
from {{ ref('matches') }} matches
inner join {{ ref('curated_wta') }} wtp
  on matches._player_id = wtp.woman_id