import os

from dagster import Definitions, load_assets_from_modules, EnvVar
from dagster_snowflake import SnowflakeResource
from dagster_dbt import DbtCliResource

from .assets import dbt_dagster_dbt_assets
from .constants import dbt_project_dir
from .schedules import schedules
from .ingestion import rankings, matches

rankings_asset = load_assets_from_modules([rankings])
matches_asset = load_assets_from_modules([matches])

defs = Definitions(
    assets=[*rankings_asset, *matches_asset, dbt_dagster_dbt_assets],
    schedules=schedules,
    resources={
        "dbt": DbtCliResource(project_dir=os.fspath(dbt_project_dir)),
        "snowflake": SnowflakeResource(
            account=EnvVar("SF_ACCOUNT"),
            user=EnvVar("SF_USER"),
            password=EnvVar("SF_PASSWORD"),
        )
    },
)