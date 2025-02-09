# LeaderOS Docker Setup

This repository contains the Docker setup for LeaderOS, including services for Caddy, Nginx, PHP, MariaDB, and phpMyAdmin.

## Prerequisites

- Docker
- Docker Compose

## Learn More

https://docs.leaderos.net/installation/docker

## Services

- **caddy**: Reverse proxy and web server, accessible on ports 80 and 443.
- **nginx**: Web server, accessible on port 8080.
- **php**: PHP-FPM service.
- **mariadb**: Database server, accessible on port 3306.
- **phpmyadmin**: Database management tool, accessible on port 8888.

## Environment Variables

- `DOMAIN`: The domain name for the services.
- `SQL_USER`: The MariaDB user.
- `SQL_PASSWORD`: The MariaDB password.
- `SQL_DATABASE`: The MariaDB database name.

## Build and start the containers:
```sh
docker compose --env-file .env up -d --build
```

## Stopping the Containers

To stop the containers, run:
```sh
docker compose down
```

## Restart the Caddy Server

To restart the Caddy server, run:
```sh
docker restart caddy
```