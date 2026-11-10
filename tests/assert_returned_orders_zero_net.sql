select order_id
from {{ ref('fct_orders') }}
where order_status = 'returned'
  and abs(net_paid_amount) > 0.01
