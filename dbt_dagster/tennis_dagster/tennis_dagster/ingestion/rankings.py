import requests
import os
from dagster import asset, MaterializeResult
from dagster_snowflake import SnowflakeResource
from snowflake.connector.pandas_tools import write_pandas
import pandas as pd



API_KEY: str = os.getenv("API_KEY")
url = f"https://api.sportradar.com/tennis/trial/v3/en/rankings.json?api_key={API_KEY}"
headers = {"accept": "application/json"}

@asset(required_resource_keys={"snowflake"}, group_name="ingestion", op_tags={"kind": "snowflake"})
def rankings_table(context):

    """
    First asset to get wtp and atp rankings
    """

    snowflake = context.resources.snowflake

    try:
        response = requests.get(url, headers=headers).text
    except Exception as e:
        print(e)
    else:
        rankings: pd.DataFrame = pd.DataFrame([{"raw":response}])
        with snowflake.get_connection() as conn:
                table_name = "RAW_RANKINGS"
                database="DAGSTER_TEST"
                schema="RAW"
                success, number_chunks, rows_inserted, output = write_pandas(
                    conn,
                    rankings,
                    table_name=table_name,
                    database=database,
                    schema=schema,
                    auto_create_table=True,
                    overwrite=True,
                    quote_identifiers=False,
                )

        return MaterializeResult(
            metadata={"rows_inserted": rows_inserted},
        )
