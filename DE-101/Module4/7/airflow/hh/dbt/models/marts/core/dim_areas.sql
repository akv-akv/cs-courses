with cte AS
     (
         select distinct
                 area_name
             from {{ ref('stg_hh__vacancies') }}
     )
 select 0 as pk_id, 'N/A' as area_name
 UNION
 select
         row_number() OVER () as pk_id
         , area_name as area_name
     from cte
