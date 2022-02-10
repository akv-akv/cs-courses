with stage AS
    (
        select *
            from {{ ref('vacancies_with_pk') }}
    )
, dim_areas AS
    (
        select *
            from {{ ref('dim_areas')}}
    )
, dim_employers AS
    (
        select *
            from {{ ref('dim_employers')}}
    )
, dim_experience_types AS
    (
        select *
            from {{ ref('dim_experience_types')}}
    )
, dim_schedule_types AS
    (
        select *
            from {{ ref('dim_schedule_types')}}
    )
, dim_currencies as
    (
        select *
            from {{ ref('dim_currencies')}}
    )
, vacancies_with_skills as
    (
        select *
            from {{ ref('vacancies_with_skills')}}
    )
, vacancies_with_matched_skills as
    (
        select *
            from {{ ref('vacancies_with_matched_skills')}}
    )
select    v.vacancy_pk_id                             as vacancy_pk_id
        , vacancy_pk_bk_id                          as vacancy_pk_bk_id
        , cast(published_at as date)                as published_date
        , to_char(published_at::time, 'hh24:mi')    as published_time
        , vacancy_name                              as vacancy_name
        , vacancy_description                       as vacancy_description
        , concat('https://hh.ru/vacancy/',
                CAST(vacancy_pk_bk_id
                as VARCHAR(20)))                     as vacancy_url
        , coalesce(skills_list,'N/A')               as skills_list
        , count_vacancy_skills                      as count_vacancy_skills
        , count_matched_skills                      as count_matched_skills
        , skills_match_percentage                   as skill_match_percentage
        , coalesce(matched_skills_list,
            'no matched skills')                    as matched_skills_list
        , coalesce(unmatched_skills_list,
            'no unmatched skills')                    as unmatched_skills_list    
        , coalesce(sch.pk_id,0)                     as fk_schedule_id
        , coalesce(ex.pk_id,0)                      as fk_experience_id
        , coalesce(a.pk_id,0)                       as fk_area_id
        , coalesce(em.pk_id,0)                      as fk_employer_id
        , v.salary_lower_limit *
            CASE WHEN salary_currency='RUR' 
                 THEN 1 
                 ELSE cur.currency_rate_value END *
            CASE WHEN is_salary_gross='True'
                 THEN 0.87 ELSE 1 END               as salary_lower_limit_rub_net
        , v.salary_upper_limit *
            CASE WHEN salary_currency='RUR' 
                 THEN 1 
                 ELSE cur.currency_rate_value END *
            CASE WHEN is_salary_gross='True'
                 THEN 0.87 ELSE 1 END               as salary_upper_limit_rub_net
        , v.salary_lower_limit  *
            CASE WHEN is_salary_gross='True' 
                 THEN 0.87 
                 ELSE 1 END                         as salary_lower_limit_local_currency_net
        , v.salary_upper_limit  *
            CASE WHEN is_salary_gross='True' 
                 THEN 0.87 
                 ELSE 1 END                         as salary_upper_limit_local_currency_net
        , v.salary_currency                         as local_currency
    from stage v
    left join dim_schedule_types sch
        ON v.schedule_name = sch.schedule_name
    left join dim_experience_types ex
        on v.experience_name = ex.experience_name
    left join dim_areas a
        on v.area_name = a.area_name
    left join dim_employers em
        on v.employer_name = em.employer_name
    left join dim_currencies cur
        on v.salary_currency = cur.currency_charcode
        and v.published_at = cur.date_at
    left join vacancies_with_skills vs
        on v.vacancy_pk_id = vs.vacancy_pk_id
    left join vacancies_with_matched_skills vms
        on v.vacancy_pk_id = vms.fk_vacancy_id
