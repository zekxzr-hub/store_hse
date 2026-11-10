# store_hse
# интернет-магазин — аналитическое хранилище
## структура проекта
### staging
- stg_shop__customers
- stg_shop__orders
- stg_shop__order_items
- stg_shop__payments
- stg_shop__products
- stg_shop__product_categories
### intermediate
- int_orders_with_payments
- int_product_categories
### marts
- fct_orders
- fct_order_items
- dim_customers
- dim_products
- dim_dates
## тестирование
- проверка уникальности и заполненности ключей
- проверка связей между таблицами
- проверка допустимых значений
- проверка числовых значений
- бизнес-тесты
## запуск проекта
запуск контейнеров:
```bash
docker compose up -d
```
проверка подключения:
```bash
docker compose run --rm dbt debug
```
сборка моделей и тестов:
```bash
docker compose run --rm dbt build
```создание документации:
```bash
docker compose run --rm dbt docs generate
```
### аналитические витрины
 витрина  зернистость  бизнес-вопрос 
 fct_orders  один заказ  выручка, средний чек, оплаты и возвраты 
 fct_order_items  один товар в заказе  выручка по товарам, категориям и брендам 
 dim_customers  один клиент  доля покупателей по каналам привлечения 
 dim_products  один товар  продажи по категориям и брендам 
 dim_dates  один календарный день  анализ продаж по периодам 
### хранение в greenplum
 витрина  распределение  причина 
 fct_orders  order_id  ключ заказов 
 fct_order_items  order_id  соединение с fct_orders по order_id 
 dim_customers  replicated  небольшая таблица клиентов 
 dim_products  replicated  небольшая таблица товаров 
 dim_dates  replicated  небольшая календарная таблица 

