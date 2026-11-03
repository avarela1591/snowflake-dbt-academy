with source_data as (
    select 
        *
    from 
        {{ source('raw_data', 'payments') }}
),
payment_method_map as (
    select
        *
    from
        {{ ref('payment_method') }}
),
cleaned as (
    select
        s.payment_id::integer as payment_id,
        s.order_id::integer as order_id,
        coalesce(trim(pmm.payment_method_clean), 'other') as payment_method,
        s.amount::decimal(10, 2) as payment_amount,
        lower(trim(s.status)) as payment_status
    from 
        source_data s
    left join payment_method_map pmm
        on lower(trim(s.payment_method)) = lower(trim(pmm.payment_method))
)
select 
    *   
from 
    cleaned