{{ config(severity='warn') }}

select order_id
from {{ ref('fct_orders') }}
where net_paid_amount > order_amount