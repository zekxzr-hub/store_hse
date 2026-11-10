select o.order_id
from {{ ref('fct_orders') }} o
join (
    select order_id, sum(line_amount) as total
    from {{ ref('fct_order_items') }}
    group by order_id
) i on o.order_id = i.order_id
where abs(o.order_amount - i.total) > 0.01
