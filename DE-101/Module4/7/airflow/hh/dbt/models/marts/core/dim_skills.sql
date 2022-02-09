with vacancies_with_pk as
    (
        select vacancy_pk_id, vacancy_pk_bk_id, key_skills
            from {{ ref('vacancies_with_pk')}}
    )
select vacancy_pk_id as fk_vacancy_id
        , trim(lower(json_array_elements(key_skills::json) ->> 'name')) as skill_name
    from vacancies_with_pk
