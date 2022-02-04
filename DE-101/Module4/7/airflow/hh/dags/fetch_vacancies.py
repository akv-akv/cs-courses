import datetime as dt
import json
import os
import pandas as pd

from sqlalchemy import create_engine
from sqlalchemy.sql import text
import sqlalchemy

from airflow import DAG

from airflow.utils.dates import days_ago
from airflow.hooks.base_hook import BaseHook
from airflow.operators.dummy import DummyOperator
from airflow.operators.python import PythonOperator
from hh.operators import HeadHunterRuFetchVacanciesOperator


dag = DAG(
    dag_id="03_operator",
    description="Fetches vacancies from the HeadHunter API using a custom operator.",
    start_date=days_ago(29),
    #end_date=days_ago(27),
    schedule_interval="@daily",
    )
vacancies_path = "/data/hh_vacancies"

start = DummyOperator(task_id="start")

fetch_vacancies = HeadHunterRuFetchVacanciesOperator(
    task_id="fetch_vacancies",
    date_from="{{ds}}",
    date_to="{{ds}}",
    text="'data engineer'",
    output_path=vacancies_path+"/{{ds}}/",
    dag=dag
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

        # dtypes = {
        #     'id': sqlalchemy.types.INTEGER,
        #     'name': sqlalchemy.types.VARCHAR(length=100),
        #     'published_at': sqlalchemy.types.TIMESTAMP,
        #     'key_skills': sqlalchemy.types.TEXT,
        #     'description': sqlalchemy.types.TEXT,
        #     'schedule_name': sqlalchemy.types.VARCHAR(length=100),
        #     'experience_name': sqlalchemy.types.VARCHAR(length=100),
        #     'area_name': sqlalchemy.types.VARCHAR(length=100),
        #     'employer_name': sqlalchemy.types.VARCHAR(length=100),
        #     'url': sqlalchemy.types.VARCHAR(length=500),
        #     'salary_to': sqlalchemy.types.INTEGER,
        #     'salary_from': sqlalchemy.types.INTEGER,
        #     'salary_currency': sqlalchemy.types.VARCHAR(length=10),
        #     'salary_gross': sqlalchemy.types.BOOLEAN,
        #     'has_test': sqlalchemy.types.BOOLEAN,
        #     'type_name': sqlalchemy.types.VARCHAR(length=100)
        # }
        
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



upload_vacancies_to_stage = PythonOperator(
    task_id="upload_vacancies_to_stage",
    python_callable=_upload_vacancies_to_stage,
    dag=dag
)

start >> [fetch_vacancies]
fetch_vacancies >> upload_vacancies_to_stage