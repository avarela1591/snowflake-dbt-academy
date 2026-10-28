with source_data as ()
    select 
        *
    from 
        {{ source('raw_data', 'orders') }}
),
cleaned as (
    select
        order_id::integer as order_id,
        customer_id::integer as customer_id,
        order_date::date as order_date,
        lower(trim(shipping_method)) as shipping_method,
    case
        when lower(trim(status)) in ('cancelled', 'canceled') then 'cancelled'
        else lower(trim(status))
    end as order_status
    from source_data
)
select
    *
from cleaned
