python
from airflow import DAG
from airflow.operators.postgres_operator import PostgresOperator
from datetime import datetime, timedelta

default_args = {
    'owner': 'airflow',
    'depends_on_past': True,
    'start_date': datetime(2021, 1, 1),
    'email': ['airflow@example.com'],
    'email_on_failure': False,
    'email_on_retry': False,
    'retries': 1,
    'retry_delay': timedelta(minutes=5),
}

dag = DAG(
    'product_transformation', default_args=default_args, schedule_interval=timedelta(1))

t1 = PostgresOperator(
    task_id='create_product_table',
    postgres_conn_id='postgres_default',
    sql="""
    CREATE TABLE IF NOT EXISTS product (
        Product_ID INT PRIMARY KEY,
        Category_Name VARCHAR(50),
        Sub_Category_Name VARCHAR(50),
        Brand VARCHAR(50),
        Feature_Desc VARCHAR(100)
    );
    """,
    dag=dag)

t2 = PostgresOperator(
    task_id='create_product_temp_table',
    postgres_conn_id='postgres_default',
    sql="""
    CREATE TEMP TABLE IF NOT EXISTS product_temp AS
    SELECT 
        a.Product_ID AS Product_ID_New,
        CASE 
            WHEN a.Category_Name <> b.Category_Name THEN '-Category_Name' 
            ELSE '' 
        END ||
        CASE 
            WHEN a.Sub_Category_Name <> b.Sub_Category_Name THEN '-Sub_Category_Name' 
            ELSE '' 
        END ||
        CASE 
            WHEN a.Brand <> b.Brand THEN '-Brand' 
            ELSE '' 
        END ||
        CASE 
            WHEN a.Feature_Desc <> b.Feature_Desc THEN '-Feature_Desc' 
            ELSE '' 
        END AS CHANGED_COLUMN_NEW
    FROM 
        Dim_Product a 
    JOIN 
        Stg_Product b
    ON 
        a.Product_ID=b.Product_ID AND a.current_flag='Y'
    WHERE
        a.Category_Name <> b.Category_Name OR
        a.Sub_Category_Name <> b.Sub_Category_Name OR
        a.Brand <> b.Brand OR
        a.Feature_Desc <> b.Feature_Desc;
    """,
    dag=dag)

t1 >> t2
