import requests

from airflow.hooks.base_hook import BaseHook


class HeadHunterRuHook(BaseHook):
    """
    Hook for the HeadHunter API

    Abstracts details of the Movielens (REST) API and provides several convenience
    methods for fetching data (e.g. vacancies lists, vacancies) from the API.

    Also
    provides support for automatic retries of failed requests, transparent
    handling of pagination, authentication, etc.
    """

    def __init__(self, retry=3) -> None:
        super().__init__()
        self._retry = retry

        self._session = None
        self._base_url = None

    def get_conn(self):
        """
        Returns the connection used by the hook for querying data.
        Should in principle not be used directly.
        """
        # Build our session instance, which we will use for any
            # requests to the API.
        self._session = requests.Session()
        self._base_url = "http://api.hh.ru"

        return self._session, self._base_url
    
    def close(self):
        """Closes any active session."""
        if self._session:
            self._session.close()
        self._session = None
        self._base_url = None


    def get_vacancies_list(self, 
                            date_from=None, 
                            date_to=None, 
                            text=None,
                            batch_size=100):
        """
        Fetches list of vacancies between the given start/end date with specific request.
        
        Parameters
        ----------
        date_from : str
            Start date to fetching vacancies list from (inclusive). Expected
            format is YYYY-MM-DD (equal to Airflow's ds formats).
        date_to : str
            End date to fetching vacancies list from (inclusive). Expected
            format is YYYY-MM-DD (equal to Airflow's ds formats).
        text : str
            Text to search for in vacancy fields. 
        """
        yield from self._get_with_pagination(
            endpoint="/vacancies",
            params={"date_from": date_from, 
                    "date_to": date_to,
                    "text": text},
            batch_size=batch_size,
        )


    def _get_with_pagination(self, endpoint, params, batch_size=100):
        """
        Fetches records using a get request with given url/params,
        taking pagination into account.
        """

        session, base_url = self.get_conn()
        url = base_url + endpoint

        page = 0
        total_pages = None
        while total_pages is None or page < total_pages:
            response = session.get(
                url, params={**params, **{"page": page, "per_page": batch_size}}
            )
            response.raise_for_status()
            response_json = response.json()

            yield from response_json["items"]

            page += 1
            total_pages = response_json["pages"]

    def get_vacancy(self, id):
        """
        Fetches vacancies by Id

        Parameters
        ----------
        id : str
            Id of a vacancy to be fetched
        """
        endpoint="/vacancies/"+id

        session, base_url = self.get_conn()
        url = base_url + endpoint

        response = session.get(url)
        response.raise_for_status()
        
        return response.json()





        
    

