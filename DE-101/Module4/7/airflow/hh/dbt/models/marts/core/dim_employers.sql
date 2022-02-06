with cte AS
     (
         select distinct
                 employer_name
             from {{ ref('stg_hh__vacancies') }}
     )
 select 0 as pk_id, 'N/A' as employer_name
 UNION
 select
         row_number() OVER () as pk_id
         , employer_name as employer_name
     from cte
