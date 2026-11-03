with source_data as (
    select 
        *
    from 
        {{ source('raw_data', 'orders') }}
),
order_status as (
    select
        *
    from
        {{ ref('orders_status') }}
),
cleaned as (
    select
        s.order_id::integer as order_id,
        s.customer_id::integer as customer_id,
        s.order_date::date as order_date,
        lower(trim(s.shipping_method)) as shipping_method,
        coalesce(trim(s.status), trim(o.status_description)) as status,
    from source_data s
    left join order_status o
        on lower(trim(s.status)) = lower(trim(o.status_code))
)
select
    *
from cleaned
