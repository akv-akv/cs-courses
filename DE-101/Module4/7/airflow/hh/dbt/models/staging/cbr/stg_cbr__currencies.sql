with source as (
    select *
    from {{ source('cbr', 'cbr_currencies') }}
),
renamed as (
    select  
            id                      as currency_id
            , numcode               as currency_numcode
            , charcode              as currency_charcode
            , nominal               as currency_nominal
            , name                  as currency_name
            , value                 as currency_rate_value
            , date                  as date_at
        from source
)
select *
from renamed