

{{
    config(
        materialized="view"
    )
}}

with raw_rankings as (

    select parse_json(raw) as json_data
    from {{ source('raw_tables', 'raw_rankings') }}

)
,
male_rankings as (

    select
        json_data:generated_at::timestamp_tz          AS generated_at
    ,   HASH(men.value:competitor.id)                 AS man_id
    ,   men.value:competitor.abbreviation::varchar(5) AS man_abbreviation
    ,   men.value:competitor.country_code::varchar(5) AS country_id
    ,   men.value:competitor.country::varchar(30)     AS country_name
    ,   men.value:movement::int                       AS movement
    ,   men.value:points::int                         AS points
    ,   men.value:rank::int                           AS rank

    from raw_rankings
    ,    lateral flatten(json_data:rankings[0]:competitor_rankings) men

)

select *
from male_rankings
