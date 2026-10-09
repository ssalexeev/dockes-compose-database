# Database schema diagram

This Mermaid ER diagram is based on [`schema.sql`](./schema.sql). Foreign-key columns are nullable unless marked `NOT NULL`.

```mermaid
erDiagram
    users {
        serial id PK
        varchar_100 email UK
        varchar_255 password_hash
        varchar_50 role
        boolean is_active
        timestamp created_at
    }

    seller_profiles {
        serial id PK
        int user_id FK
        varchar_100 store_name
        text store_description
        timestamp created_at
    }

    products {
        serial id PK
        int seller_id FK
        varchar_100 title
        text description
        decimal_10_2 price
        int stock_quantity
        varchar_255 image_url
        varchar_50 product_type
        timestamp created_at
    }

    categories {
        serial id PK
        int parent_category_id FK
        varchar_100 name UK
        text description
        timestamp created_at
    }

    product_categories {
        int product_id PK, FK
        int category_id PK, FK
    }

    carts {
        serial id PK
        int user_id FK
        decimal_10_2 total_amount
        timestamp updated_at
    }

    orders {
        serial id PK
        int user_id FK
        varchar_50 status
        decimal_10_2 total_amount
        timestamp created_at
        timestamp updated_at
    }

    cart_items {
        serial id PK
        int cart_id FK
        int product_id FK
        int quantity
        timestamp created_at
    }

    order_items {
        serial id PK
        int order_id FK
        int product_id FK
        int quantity
        decimal_10_2 unit_price
        timestamp created_at
    }

    sales_analytics_reports {
        serial id PK
        int product_id FK
        date period_start
        date period_end
        jsonb aggregated_metrics
        text ai_insights_text
        timestamp created_at
    }

    user_metric_events {
        serial id PK
        int user_id FK
        varchar_100 event_type
        text search_query
        timestamp created_at
    }

    users o|--o{ seller_profiles : "fk_seller_profiles_on_users"
    seller_profiles o|--o{ products : "fk_products_on_seller_profiles"
    categories o|--o{ categories : "fk_categories_on_categories"
    products ||--o{ product_categories : "fk_product_categories_on_products"
    categories ||--o{ product_categories : "fk_product_categories_on_categories"
    users o|--o{ carts : "fk_carts_on_users"
    users o|--o{ orders : "fk_orders_on_users"
    carts o|--o{ cart_items : "fk_cart_items_on_carts"
    products o|--o{ cart_items : "fk_cart_items_on_products"
    orders o|--o{ order_items : "fk_order_items_on_orders"
    products o|--o{ order_items : "fk_order_items_on_products"
    products o|--o{ sales_analytics_reports : "fk_sales_analytics_reports_on_products"
    users o|--o{ user_metric_events : "fk_user_metric_events_on_users"
```

`product_categories` is the junction table implementing the many-to-many relationship between `products` and `categories`.
