{{ config(distributed_replicated=true) }}

with calendar as (
    {{ dbt_utils.date_spine(
        datepart="day",
        start_date="(select min(order_date) from " ~ ref('fct_orders') ~ ")",
        end_date="(select max(order_date) + 1 from " ~ ref('fct_orders') ~ ")"
    ) }}
)

select
    date_day::date as order_date,
    extract(year from date_day)::integer as year,
    extract(quarter from date_day)::integer as quarter,
    extract(month from date_day)::integer as month,
    extract(day from date_day)::integer as day,
    extract(isodow from date_day)::integer as day_of_week,
    extract(isodow from date_day) in (6, 7) as is_weekend
from calendar