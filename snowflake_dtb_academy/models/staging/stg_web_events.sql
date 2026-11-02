with source_data as (
    select 
        *
    from 
        {{ source('raw_data', 'web_events') }}
),
flattened as (
    select
        event_id::integer as event_id,
        received_at::timestamp_ntz as received_at,
        payload:event_type::string as event_type,
        payload:order_id::integer as order_id,
        payload:user_id::integer as user_id,
        payload:total::decimal(10, 2) as total_amount,
        --Nested Device Object
        payload:device:type::string as device_type,
        payload:device:os::string as device_os,
        payload:device:browser::string as device_browser,
        -- Nested Items Array
        payload:items[0]:price::decimal(10, 2) as product_price,
        payload:items[0]:product_id::integer as product_id,
        payload:items[0]:qty::integer as product_qty,
        -- Nested UTM Object
        payload:utm:source::string as utm_source,
        payload:utm:medium::string as utm_medium,
        payload:utm:campaign::string as utm_campaign
    from 
        source_data
)
select 
    *   
from 
    flattened