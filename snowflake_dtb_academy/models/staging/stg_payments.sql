with source_data as (
    select 
        *
    from 
        {{ source('raw_data', 'payments') }}
),
cleaned as (
    select
        payment_id::integer as payment_id,
        order_id::integer as order_id,
        CASE
            WHEN payment_method IN ('credit_card', 'cc', 'visa', 'mastercard', 'amex') THEN 'credit_card'
            WHEN payment_method IN ('bank_transfer', 'wire', 'ach') THEN 'bank_transfer'
            WHEN payment_method IN ('paypal', 'venmo') THEN 'digital_wallet'
            WHEN payment_method = 'gift_card' THEN 'gift_card'
            ELSE 'other' 
        END as payment_method,
        amount::decimal(10, 2) as payment_amount,
        lower(trim(status)) as payment_status
    from 
        source_data
)
select 
    *   
from 
    cleaned