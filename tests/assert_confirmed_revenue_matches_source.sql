with p as (
    select distinct order_id
    from {{ source('shop', 'payments') }}
    where payment_status = 'success' and amount > 0
),
s as (
    select coalesce(sum(o.total_amount), 0) as source_amount
    from {{ source('shop', 'orders') }} o
    join p on o.order_id = p.order_id
    where o.status = 'paid'
),
m as (
    select coalesce(sum(order_amount), 0) as mart_amount
    from {{ ref('fct_orders') }}
    where is_confirmed
)
select *
from s cross join m
where abs(source_amount - mart_amount) > 0.01
