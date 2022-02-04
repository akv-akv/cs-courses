with cte AS
     (
         select distinct
                 experience_name
             from "de101m04cp"."dm"."stg_hh__vacancies"
     )
 select 0 as pk_id, 'N/A' as experience_name
 UNION
 select
         row_number() OVER () as pk_id
         , experience_name as experience_name
     from cte
