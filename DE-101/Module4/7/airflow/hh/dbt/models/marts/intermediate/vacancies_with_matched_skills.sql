with dim_skills AS
    (
        select *
            from {{ ref('dim_skills') }}
    )
, my_skills AS
    (
        select *
            from {{ ref('my_skills') }}
    )
, skills_count as
    (
        select skill_name, count(*) as cnt
            from dim_skills
            group by skill_name
    )
select  fk_vacancy_id
        , COUNT(vs.skill_name) as count_vacancy_skills
        , COUNT(ms.skill_name) as count_matched_skills
        , CAST(COUNT(ms.skill_name) as FLOAT) / COUNT(vs.skill_name) as skills_match_percentage
        , STRING_AGG(ms.skill_name, ', ' order by cnt desc) as matched_skills_list
        , STRING_AGG(CASE WHEN ms.skill_name IS NULL 
                        THEN sc.skill_name END, ', ' order by cnt desc) as unmatched_skills_list
    from dim_skills vs
    left join my_skills ms
        ON vs.skill_name = ms.skill_name
    join skills_count sc
        on vs.skill_name = sc.skill_name 
    group by fk_vacancy_id