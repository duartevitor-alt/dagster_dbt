{{
  config(
    materialized = 'table',
    )
}}

select * 
from {{ ref('matches') }} matches
inner join {{ ref('dim_atp') }} atp
  on matches._player_id = atp.man_id