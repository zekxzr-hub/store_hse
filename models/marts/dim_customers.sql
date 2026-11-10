
{{ config(distributed_replicated=true) }}

-- Одна строка — один клиент, включая клиентов без покупок.
with customers as (
    select *
    from {{ ref('stg_shop__customers') }}
),

orders as (
    select *
    from {{ ref('fct_orders') }}
    where is_confirmed
),

ranked_orders as (
    select
        customer_id,
        order_id,
        first_paid_at,
        row_number() over (
            partition by customer_id
            order by first_paid_at, order_id
        ) as rn
    from orders
),

customer_stats as (
    select
        customer_id,
        count(*) as confirmed_orders_count,
        sum(order_amount) as confirmed_revenue
    from orders
    group by customer_id
)

select
    c.customer_id,
    c.registered_at,
    c.registration_date,
    c.city,
    c.acquisition_channel,
    f.order_id as first_confirmed_order_id,
    f.first_paid_at as first_confirmed_at,
    coalesce(s.confirmed_orders_count, 0) as confirmed_orders_count,
    coalesce(s.confirmed_revenue, 0) as confirmed_revenue,
    coalesce(s.confirmed_orders_count, 0) > 0 as is_buyer
from customers as c
left join ranked_orders as f
    on c.customer_id = f.customer_id
    and f.rn = 1
left join customer_stats as s
    on c.customer_id = s.customer_id
