{{
    config(
        materialized="table",
        alias='wta'
    )
}}

with raw_rankings as (

    select parse_json(raw) as json_data
    from {{ source('raw_tables', 'raw_rankings') }}

)
,
female_rankings as (

    select
        json_data:generated_at::timestamp_tz            AS generated_at
    ,   HASH(women.value:competitor.id)                 AS woman_id
    ,   women.value:competitor.abbreviation::varchar(5) AS woman_abbreviation
    ,   women.value:competitor.country_code::varchar(5) AS country_id
    ,   women.value:competitor.country::varchar(30)     AS country_name
    ,   women.value:movement::int                       AS movement
    ,   women.value:points::int                         AS points
    ,   women.value:rank::int                           AS rank


    from raw_rankings
    ,    lateral flatten(json_data:rankings[1]:competitor_rankings) women

)

select *
from female_rankings
