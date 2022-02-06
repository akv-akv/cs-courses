select currency_charcode
    , currency_name
    , currency_rate_value
    , date_at
    from {{ ref('stg_cbr__currencies') }}