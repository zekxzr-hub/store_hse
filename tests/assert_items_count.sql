select count(*) as actual
from {{ ref('fct_order_items') }}
having count(*) != 425