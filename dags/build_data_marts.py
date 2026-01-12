from airflow import DAG
from airflow.providers.postgres.operators.postgres import PostgresOperator
from airflow.operators.python import PythonOperator # เพิ่มตัวนี้
from datetime import datetime, timedelta
import pandas as pd
import matplotlib.pyplot as plt
import seaborn as sns
from sqlalchemy import create_engine
import os


def generate_report_image():
    # ใช้ Host เป็น 'postgres' เพราะรันภายใน Docker Network เดียวกัน
    DB_URL = "postgresql://masterkey1121:mymomiskindofhomeless@postgres:5432/olist_warehouse"
    engine = create_engine(DB_URL)
    
    sns.set_theme(style="whitegrid")
    fig, axes = plt.subplots(2, 2, figsize=(20, 15))
    fig.suptitle('Olist Daily Data Mart Report', fontsize=24, fontweight='bold')

    # 1. Revenue Trend
    df_sales = pd.read_sql("SELECT * FROM revenue_by_month ORDER BY year, month", engine)
    df_sales['period'] = df_sales['month_name'] + " " + df_sales['year'].astype(str)
    sns.lineplot(ax=axes[0, 0], data=df_sales, x='period', y='revenue', marker='o', color='b')
    axes[0, 0].set_title('Monthly Revenue')
    axes[0, 0].tick_params(axis='x', rotation=45)

    # 2. Top Selling
    df_top = pd.read_sql("SELECT * FROM best_selling ORDER BY revenue DESC LIMIT 10", engine)
    sns.barplot(ax=axes[0, 1], data=df_top, x='revenue', y='product_category_name', palette='viridis')
    axes[0, 1].set_title('Top 10 Categories')

    # 3. Geography
    df_geo = pd.read_sql("SELECT * FROM revenue_by_state ORDER BY revenue DESC LIMIT 10", engine)
    sns.barplot(ax=axes[1, 0], data=df_geo, x='customer_state', y='revenue', palette='magma')
    axes[1, 0].set_title('Revenue by State')

    # 4. Market Basket
    df_mkt = pd.read_sql("SELECT * FROM frequently_bought_together ORDER BY pair_count DESC LIMIT 10", engine)
    df_mkt['pair'] = df_mkt['product_category_a'] + " + " + df_mkt['product_category_b']
    sns.barplot(ax=axes[1, 1], data=df_mkt, x='pair_count', y='pair', palette='rocket')
    axes[1, 1].set_title('Commonly Bought Together')

    plt.tight_layout(rect=[0, 0.03, 1, 0.95])
    
    # บันทึกไฟล์ลงในโฟลเดอร์ logs หรือโฟลเดอร์ที่แชร์ไว้
    output_path = '/opt/airflow/logs/daily_report.png'
    plt.savefig(output_path, dpi=300)
    print(f"Report saved to {output_path}")



# Define default arguments for the DAG
default_args = {
    'owner': 'masterkey11',
    'retries': 1,
    'retry_delay': timedelta(minutes=5),
}

# Initialize the DAG
with DAG(
    dag_id='olist_datamart_pipeline_v1',
    default_args=default_args,
    start_date=datetime(2025, 1, 9),
    schedule_interval='@daily', # รันทุกวัน
    template_searchpath=['/opt/airflow/sql_datamart_query'],
    catchup=False
) as dag:

    # Create tasks using PostgresOperator
    t1_create_mart_table = PostgresOperator(
        task_id='create_mart_table',
        postgres_conn_id='postgres_default',
        sql='01_create_mart_table.sql'
    )

    t2_load_best_sellling = PostgresOperator(
        task_id='load_best_selling',
        postgres_conn_id='postgres_default',
        sql='02_etl_bestselling.sql'
    )

    t3_load_revenue_by_month = PostgresOperator(
        task_id='load_revenue_by_month',
        postgres_conn_id='postgres_default',
        sql='03_etl_revenue_by_month.sql'
    )

    t4_load_revenue_by_state = PostgresOperator(
        task_id='load_revenue_by_state',
        postgres_conn_id='postgres_default',
        sql='04_etl_revenue_by_state.sql'
    )

    t5_load_avg_installments_by_category = PostgresOperator(
        task_id='load_avg_installments_by_category',
        postgres_conn_id='postgres_default',
        sql='05_etl_avg_installments_by_category.sql'
    )

    t6_load_frequently_bought_together = PostgresOperator(
        task_id='load_frequently_bought_together',
        postgres_conn_id='postgres_default',
        sql='06_etl_frequently_bought_together.sql'
    )

    t7_generate_report = PythonOperator(
        task_id='generate_report_image',
        python_callable=generate_report_image
    )

    # Define task dependencies
    t1_create_mart_table >> [t2_load_best_sellling,
                             t3_load_revenue_by_month,
                             t4_load_revenue_by_state,
                             t5_load_avg_installments_by_category,
                             t6_load_frequently_bought_together
                             ] >> t7_generate_report