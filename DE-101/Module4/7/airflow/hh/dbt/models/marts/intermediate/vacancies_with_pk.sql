select row_number() OVER () as vacancy_pk_id
                ,*
            from {{ ref('stg_hh__vacancies') }}