# Local PostgreSQL with Docker Compose

This project defines a local PostgreSQL database using Docker Compose. The manifest in `docker-compose.yaml` starts a single database container and exposes it on the configured host port.

See [schema_diagram.md](./schema_diagram.md) for the entity-relationship diagram based on `schema.sql`.

## Prerequisites

- Docker Engine installed and running
- Docker Compose v2 (`docker compose`) available in your shell

## 1. Configure environment variables

Create or review the `.env` file in this directory. The values below are already set for a local development database:

```env
POSTGRES_USER=myuser
POSTGRES_PASSWORD=mypassword
POSTGRES_DB=mydatabase
POSTGRES_PORT=5432
```

If you want to use a different database name, user, or port, update the values in `.env` before starting the container.

## 2. Start the database

From this directory, run:

```bash
docker compose up -d db
```

This creates and starts the PostgreSQL container in the background.

## 3. Verify the database is running

Check the container status:

```bash
docker compose ps
```

You should see the `db` service as `running`.

To inspect the database logs:

```bash
docker compose logs -f db
```

## 4. Connect to the database locally

The database is exposed on your host machine at `localhost:<POSTGRES_PORT>`. With the default configuration, that is:

```bash
psql -h localhost -p 5432 -U myuser -d mydatabase
```

When prompted, enter the password from `.env`:

```text
mypassword
```

## 5. Stop and remove the database

To stop the container:

```bash
docker compose stop db
```

To stop it and remove the container and its default network:

```bash
docker compose down
```

To remove the database volume as well (delete all local database data):

```bash
docker compose down -v
```

## Initialize the schema

On the first start with a new database volume, Docker Compose mounts `schema.sql` into PostgreSQL's initialization directory. The official PostgreSQL image runs it automatically when it creates the database:

```bash
docker compose up -d db
```

Confirm initialization by listing the tables:

```bash
docker compose exec db psql -U myuser -d mydatabase -c '\dt'
```

Replace `myuser` and `mydatabase` with the `POSTGRES_USER` and `POSTGRES_DB` values from `.env` if you changed the defaults.

Standalone table definitions in `tables/` mirror `schema.sql`. If you need to apply them individually to a new, empty database, use this foreign-key-safe order:

```bash
for table in users seller_profiles products categories product_categories carts orders cart_items order_items sales_analytics_reports user_metric_events; do
  docker compose exec -T db psql -v ON_ERROR_STOP=1 -U myuser -d mydatabase < "tables/${table}.sql"
done
```

Do not run the individual scripts if `schema.sql` has already initialized the database.

### Apply the schema to an existing empty database

Initialization scripts run only when PostgreSQL creates a new data directory. If the `db_data` volume already exists and the target database is empty, apply the schema explicitly:

```bash
docker compose exec -T db psql -v ON_ERROR_STOP=1 -U myuser -d mydatabase < schema.sql
```

This schema contains `CREATE TABLE` statements and is not safe to rerun against a database where those tables already exist. For changes to a database with existing tables or data, write a separate, versioned migration containing the needed `ALTER TABLE` or other incremental statements, then apply that migration explicitly. Do not remove `db_data` to apply a schema update unless you intend to delete all database data.

## Notes

- The Compose file maps the container's internal PostgreSQL port `5432` to the host port configured by `POSTGRES_PORT`.
- The database data is stored in the Docker named volume `db_data`, so it persists across container restarts unless you explicitly remove it with `docker compose down -v`.
