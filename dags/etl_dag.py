from airflow import DAG
from airflow.providers.postgres.operators.postgres import PostgresOperator
from datetime import datetime, timedelta

# Define default arguments for the DAG
default_args = {
    'owner': 'masterkey11',
    'retries': 1,
    'retry_delay': timedelta(minutes=5),
}

# Initialize the DAG
with DAG(
    dag_id='olist_dw_pipeline_v1',
    default_args=default_args,
    start_date=datetime(2025, 1, 9),
    schedule_interval='@daily', # รันทุกวัน
    template_searchpath=['/opt/airflow/sql'],
    catchup=False
) as dag:

    # Create tasks using PostgresOperator
    t1_setup_staging = PostgresOperator(
        task_id='setup_staging',
        postgres_conn_id='postgres_default',
        sql='01_setup_database.sql'
    )

    t2_create_dims = PostgresOperator(
        task_id='create_dimensions',
        postgres_conn_id='postgres_default',
        sql='02_create_dimensions.sql'
    )

    t3_create_facts = PostgresOperator(
        task_id='create_facts',
        postgres_conn_id='postgres_default',
        sql='03_create_facts.sql'
    )

    t4_load_dims = PostgresOperator(
        task_id='load_dimensions',
        postgres_conn_id='postgres_default',
        sql='04_etl_dimensions.sql'
    )

    t5_load_facts = PostgresOperator(
        task_id='load_facts',
        postgres_conn_id='postgres_default',
        sql='05_etl_facts.sql'
    )

    # Define task dependencies
    t1_setup_staging >> t2_create_dims >> t3_create_facts >> t4_load_dims >> t5_load_facts