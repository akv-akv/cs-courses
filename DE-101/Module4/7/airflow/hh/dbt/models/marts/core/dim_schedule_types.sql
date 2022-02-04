with cte AS
     (
         select distinct
                 schedule_name
             from "de101m04cp"."dm"."stg_hh__vacancies"
     )
 select 0 as pk_id, 'N/A' as schedule_name
 UNION
 select
         row_number() OVER () as pk_id
         , schedule_name as schedule_name
     from cte
