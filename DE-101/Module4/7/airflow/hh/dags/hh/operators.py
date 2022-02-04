import json
import os

from airflow.models import BaseOperator
from airflow.utils.decorators import apply_defaults

from hh.hooks import HeadHunterRuHook

class HeadHunterRuFetchVacanciesOperator(BaseOperator):
    """
    Operator that fetches vacancies from the HeadHunterRu API 

    Parameters
    ----------
    output_path : str
        Path to write the fetched vacancies to.
    date_from : str
        Start date to fetching vacancies list from (inclusive). Expected
        format is YYYY-MM-DD (equal to Airflow's ds formats).
    date_to : str
        End date to fetching vacancies list from (inclusive). Expected
        format is YYYY-MM-DD (equal to Airflow's ds formats).
    text : str
        Text to search for in vacancy fields.
    batch_size : int
        Size of the batches (pages) to fetch from the API. Larger values
        mean less requests, but more data transferred per request. Max 100.
    """

    template_fields = ("_date_from", "_date_to", "_text", "_output_path")

    @apply_defaults
    def __init__(self,
                output_path,
                date_from="{{ds}}",
                date_to="{{ds}}",
                text="data engineer",
                batch_size=100,
                **kwargs) -> None:
        super(HeadHunterRuFetchVacanciesOperator, self).__init__(**kwargs)

        self._output_path = output_path
        self._date_from = date_from
        self._date_to = date_to
        self._batch_size = batch_size
        self._text = text

    def execute(self, context):
        hook = HeadHunterRuHook()

        try:
            self.log.info(
                f"Fetching vacancies for {self._date_from} to {self._date_to} with text '{self._text}'"
            )
            vacancies_list = list(
                hook.get_vacancies_list(
                    date_from=self._date_from,
                    date_to=self._date_to,
                    text=self._text,
                    batch_size=self._batch_size
                )
            )
            self.log.info(f"Fetched {len(vacancies_list)} vacancies")
        finally:
            hook.close()

        # Make sure output directory exists.
        output_dir = os.path.dirname(self._output_path)
        os.makedirs(output_dir, exist_ok=True)

        for vacancy in vacancies_list:
            id = vacancy['id']
            self.log.info(
                f"Fetching detailed info for vacancy {id}"
            )
            vacancy_details = hook.get_vacancy(id)
            self.log.info(f"Write vacancy {id} to {self._output_path}")
            
            # Write output as JSON.
            with open(self._output_path+id+'.json', "w") as file_:
                json.dump(vacancy_details, fp=file_, ensure_ascii=False)

        
        

        

