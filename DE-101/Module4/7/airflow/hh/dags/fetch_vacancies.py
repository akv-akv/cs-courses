import datetime as dt
import json
import os
import pandas as pd

from sqlalchemy import create_engine
from sqlalchemy.sql import text
import sqlalchemy
import xmltodict
from lxml import etree

from airflow import DAG

from airflow.utils.dates import days_ago
from airflow.hooks.base_hook import BaseHook
from airflow.operators.dummy import DummyOperator
from airflow.operators.python import PythonOperator
from airflow.operators.bash import BashOperator
from airflow.providers.docker.operators.docker import DockerOperator
from airflow.operators.latest_only import LatestOnlyOperator


from hh.operators import HeadHunterRuFetchVacanciesOperator


dag = DAG(
    dag_id="hh_dwh",
    description="Fetches vacancies from the HeadHunter API using a custom operator.",
    start_date=days_ago(29),
    schedule_interval="@daily",
    )
vacancies_path = "/data/hh_vacancies"
currency_rates_path = "/data/cbr_currencies"

start = DummyOperator(task_id="start", 
                        depends_on_past=True,
                        wait_for_downstream=True)

fetch_vacancies = HeadHunterRuFetchVacanciesOperator(
    task_id="fetch_vacancies",
    date_from="{{ds}}",
    date_to="{{ds}}",
    text='NAME:("data engineer" OR "etl" OR "dwh")',
    output_path=vacancies_path+"/{{ds}}/",
    dag=dag
)

fetch_currencies = BashOperator(
    task_id="fetch_currencies",
    bash_command=(
        f"mkdir -p /data/cbr_currency_rates && "
        "curl -o /data/cbr_currency_rates/{{execution_date.strftime('%Y%m%d')}}.xml -L "
        "'http://www.cbr.ru/scripts/XML_daily_eng.asp?date_req={{execution_date.strftime('%d/%m/%Y')}}'"
    ),
    dag=dag,
)

def _upload_currency_rates_to_stage(**context):
    ds = context["ds_nodash"]

    with open(f"/data/cbr_currency_rates/{ds}.xml",'r') as f:
        my_xml = f.read()
    
    my_dict = xmltodict.parse(my_xml)['ValCurs']['Valute']

    currency_rates = pd.DataFrame(my_dict)
    currency_rates['date'] = f"{ds}"
    currency_rates = currency_rates.rename(columns={'@ID':'id'})
    currency_rates.columns= currency_rates.columns.str.lower()
    currency_rates['value'] = currency_rates['value'].str.replace(',','.')
    engine = create_engine(BaseHook.get_connection('de101m04cp').get_uri())
        
    with engine.begin() as conn:
        
        query = text("""DELETE FROM stg.cbr_currencies 
                        WHERE date = :date;""")
        conn.execute(query, {'date':f"'{ds}'"})
        currency_rates.to_sql(schema='stg',
                                name='cbr_currencies', 
                                con=conn, 
                                index=False, 
                                if_exists="append",
                                )

    

def _upload_vacancies_to_stage(**context):
    ds = context["ds"]
    next_ds = context["next_ds"]
    input_path=vacancies_path+f"/{ds}/"

    json_files = [pos_json for pos_json in os.listdir(input_path) if pos_json.endswith('.json')]

    if len(json_files) > 0:
        expected_columns = {
            'id',
            'name',
            'published_at',
            'key_skills',
            'description',
            'schedule_name',
            'experience_name',
            'area_name',
            'employer_name',
            'url',
            'salary_to',
            'salary_from',
            'salary_currency',
            'salary_gross',
            'has_test',
            'type_name'
        }
        
        vacancies = pd.DataFrame(columns=list(expected_columns))
        for json_file in json_files:
            with open(input_path+"/"+json_file,'r') as f:
                data = f.read()
            df = pd.json_normalize(json.loads(data), sep='_')
            
            # Fill with null value columns that are not given in vacancy details, but expected to exist
            for column in expected_columns - set(df.columns):
                df[column] = None
                
            df = df[list(expected_columns)]
            vacancies = vacancies.append(df)
        
        vacancies = vacancies[list(expected_columns)]
        vacancies['key_skills'] = list(map(lambda x: json.dumps(x, ensure_ascii=False), vacancies['key_skills']))
        vacancy_id_list = list(vacancies['id'])
        
        engine = create_engine(BaseHook.get_connection('de101m04cp').get_uri())
        
        with engine.begin() as conn:
            for id in vacancy_id_list:
                query = text("""DELETE FROM stg.hh_vacancies 
                        WHERE id = :id;""")
                conn.execute(query, {'id':id})
            vacancies.to_sql(schema='stg',
                            name='hh_vacancies', 
                            con=conn, 
                            index=False, 
                            if_exists="append",
                            #dtype=dtypes
                            )

latest_only = LatestOnlyOperator(
    task_id="latest_only",
    dag=dag,
)


upload_vacancies_to_stage = PythonOperator(
    task_id="upload_vacancies_to_stage",
    python_callable=_upload_vacancies_to_stage,
    dag=dag
)

upload_currency_rates_to_stage = PythonOperator(
    task_id="upload_currency_rates_to_stage",
    python_callable=_upload_currency_rates_to_stage,
    dag=dag
)

join_branch = DummyOperator(
           task_id="join_branch",
           trigger_rule="none_failed"
)

DBT_DIR = "/opt/airflow/dbt"

dbt_run = BashOperator(
    task_id="dbt_run",
    bash_command=(
        f"cd {DBT_DIR} && dbt run --profiles-dir {DBT_DIR}"
    ),
    dag=dag,
)

dbt_test = BashOperator(
    task_id="dbt_test",
    bash_command=(
        f"cd {DBT_DIR} && dbt test --profiles-dir {DBT_DIR}"
    ),
    dag=dag,
)

dbt_docs = BashOperator(
    task_id="dbt_docs",
    bash_command=(
        f"cd {DBT_DIR} && dbt docs generate --profiles-dir {DBT_DIR}"
    ),
    dag=dag,
)

start >> [fetch_vacancies, fetch_currencies]
fetch_vacancies >> upload_vacancies_to_stage
fetch_currencies >> upload_currency_rates_to_stage
[upload_vacancies_to_stage, upload_currency_rates_to_stage] >> join_branch
join_branch >> latest_only >> dbt_run >> dbt_test >>dbt_docs
