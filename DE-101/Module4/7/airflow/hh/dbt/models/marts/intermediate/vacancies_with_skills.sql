with dim_skills AS
    (
        select *
            from {{ ref('dim_skills') }}
    )
, skills_count as
    (
        select skill_name, count(*) as cnt
            from dim_skills
            group by skill_name
    )
, dim_skills_with_vacancy_id AS
    (   
        select DISTINCT s.fk_vacancy_id
                , STRING_AGG(s.skill_name, ', ' order by cnt desc) as skill_name_list
            from dim_skills s 
            join skills_count sc
                on s.skill_name = sc.skill_name 
            group by s.fk_vacancy_id
    )
select fk_vacancy_id as vacancy_pk_id
        , COALESCE(skill_name_list,'N/A') as skill_name_list
    from  dim_skills_with_vacancy_id 