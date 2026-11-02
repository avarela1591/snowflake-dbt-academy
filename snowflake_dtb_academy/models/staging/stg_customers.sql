with source_data as (
    select 
        *
    from 
        {{ source('raw_data', 'customers') }}
),
country_map as (
    select
        *
    from
        {{ ref('country_mapping') }}
),
cleaned as (
    select
        s.customer_id::integer as customer_id,
        trim(upper(s.first_name)) as first_name,
        trim(upper(s.last_name)) as last_name,
        trim(lower(s.email)) as email,
        coalesce(trim(s.phone), 'N/A') as phone_number,
        trim(upper(s.country)) as country,
        coalesce(cm.country_code, trim(upper(s.country))) as country_code,
        created_at::timestamp_ntz as created_at
    from 
        source_data s
    left join country_map cm
        on trim(upper(s.country)) = trim(upper(cm.country_raw))
    where
        created_at is not null
        and email is not null
        and email like '%@%'
    qualify row_number() over (partition by lower(trim(email)) order by created_at desc) = 1
)
select 
    *
from 
    cleaned
