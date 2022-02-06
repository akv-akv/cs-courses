with source as (
    select *
    from {{ source('hh', 'hh_vacancies') }}
),
renamed as (
    select  
            id                      as vacancy_pk_bk_id
            , name                  as vacancy_name
            , published_at          as published_at
            , key_skills            as key_skills
            , description           as vacancy_description
            , schedule_name         as schedule_name
            , experience_name       as experience_name
            , area_name             as area_name
            , employer_name         as employer_name
            , salary_to             as salary_upper_limit
            , salary_from           as salary_lower_limit
            , salary_currency       as salary_currency
            , salary_gross          as is_salary_gross
            , has_test              as is_with_test
            , updated_at            as updated
        from source
)
select *
from renamed