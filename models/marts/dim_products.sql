
{{ config(distributed_replicated=true) }}

-- Одна строка — один товар с полной иерархией категорий.
with products as (
    select *
    from {{ ref('stg_shop__products') }}
),

categories as (
    select
        category_name,
        parent_category_name,
        root_category_name
    from {{ ref('int_product_categories') }}
)

select
    p.product_id,
    p.product_name,
    p.brand,
    p.category as category_name,
    c.parent_category_name,
    c.root_category_name
from products as p
left join categories as c
    on p.category = c.category_name
