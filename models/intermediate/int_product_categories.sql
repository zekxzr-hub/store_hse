with recursive categories as (
    select *
    from {{ ref('stg_shop__product_categories') }}
),

category_tree as (
    select
        category_id,
        parent_category_id,
        category_name,
        null::text as parent_category_name,
        category_id as root_category_id,
        category_name as root_category_name,
        1 as category_level
    from categories
    where parent_category_id is null

    union all

    select
        c.category_id,
        c.parent_category_id,
        c.category_name,
        t.category_name as parent_category_name,
        t.root_category_id,
        t.root_category_name,
        t.category_level + 1
    from categories as c
    join category_tree as t
        on c.parent_category_id = t.category_id
)

select *
from category_tree
