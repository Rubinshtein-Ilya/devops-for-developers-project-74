# devops-for-developers-project-74

### Hexlet tests and linter status:
[![Actions Status](https://github.com/Rubinshtein-Ilya/devops-for-developers-project-74/actions/workflows/hexlet-check.yml/badge.svg)](https://github.com/Rubinshtein-Ilya/devops-for-developers-project-74/actions)

### Push CI status:
[![Push CI](https://github.com/Rubinshtein-Ilya/devops-for-developers-project-74/actions/workflows/push.yml/badge.svg)](https://github.com/Rubinshtein-Ilya/devops-for-developers-project-74/actions/workflows/push.yml)

Учебный проект: упаковка приложения (блог на [Fastify](https://fastify.dev/))
в Docker Compose с продакшен-сборкой, PostgreSQL, reverse proxy (Caddy)
и непрерывной интеграцией через GitHub Actions.

Готовый образ на Docker Hub:
[irubinshtein/devops-for-developers-project-74](https://hub.docker.com/r/irubinshtein/devops-for-developers-project-74)

```bash
docker run -p 8080:8080 -e NODE_ENV=development irubinshtein/devops-for-developers-project-74
```

## Требования

- Docker
- Docker Compose (спецификация не ниже 1.27.0)
- make

## Структура

- `app/` — приложение (Fastify + Sequelize)
- `Dockerfile` — образ для локальной разработки (код монтируется томом)
- `Dockerfile.production` — продакшен-образ (зависимости, сборка ассетов)
- `docker-compose.yml` — базовая схема: тесты/прод, PostgreSQL с хелсчеком
- `docker-compose.override.yml` — локальная разработка: bind-mount кода, Caddy (https), порты
- `services/caddy/Caddyfile` — конфигурация reverse proxy

## Подготовка

```bash
make setup   # установка зависимостей приложения в контейнере
```

Приложение конфигурируется переменными окружения (`DATABASE_HOST`,
`DATABASE_NAME`, `DATABASE_USERNAME`, `DATABASE_PASSWORD`, `DATABASE_PORT`).

Docker Compose подставляет их из корневого `.env` (создаётся копированием
`.env.example`); если файла нет, действуют значения по умолчанию —
именно они используются в CI:

```bash
cp .env.example .env
```

Для запуска приложения вне Docker переменные читаются через dotenv
из `app/.env`:

```bash
cp app/.env.example app/.env
```

## Запуск (разработка)

```bash
make dev     # docker compose up: app + postgres + caddy
```

- <http://localhost> — редирект на https
- <https://localhost> — приложение через Caddy (самоподписной сертификат)
- <http://localhost:8080> — приложение напрямую

## Тесты

```bash
make test    # прогон тестов в продакшен-образе через Docker Compose
make ci      # то же, используется в CI
```

## Прочие команды

```bash
make build   # сборка продакшен-образа
make push    # публикация образа на Docker Hub
```

## CI

На каждый push в `main` GitHub Actions ([push.yml](.github/workflows/push.yml)):
собирает продакшен-образ через [docker/build-push-action](https://github.com/docker/build-push-action)
(с кешированием слоёв в кеше GitHub Actions), прогоняет на нём тесты внутри
Docker Compose и публикует этот же образ на Docker Hub с тегом `latest`.
