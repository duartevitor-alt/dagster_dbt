{{
    config(
        materialized="table"
    )
}}

{# with json_data as (

    select parse_json(raw) as json
    from {{ source('raw_tables', 'raw_matches') }}

)

select 
    hash(comp.value:id)    as _player_id  
,   comp.value:id = summa.value:sport_event_status:winner_id as is_winner
from json_data
, lateral flatten(json:summaries) summa
, lateral flatten(summa.value:sport_event:competitors) comp #}
select 10 id union all select 12 