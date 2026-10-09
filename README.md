# Local PostgreSQL with Docker Compose

This project defines a local PostgreSQL database using Docker Compose. The manifest in `docker-compose.yaml` starts a single database container and exposes it on the configured host port.

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

## Notes

- The Compose file maps the container's internal PostgreSQL port `5432` to the host port configured by `POSTGRES_PORT`.
- The database data is stored in the Docker named volume `db_data`, so it persists across container restarts unless you explicitly remove it with `docker compose down -v`.
