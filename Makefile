# Help command
.DEFAULT_GOAL := help

help:
	@echo "Available commands:"
	@echo ""
	@echo "💡 Tip: You can also use 'make' or 'make help' to see this message"
	@echo ""
	@echo "Docker Compose Management:"
	@echo "  make app-build                   - Build and start all app services (daemon mode)"
	@echo "  make monitoring-build            - Build and start all monitoring services (daemon mode)"
	@echo "  make app-up                      - Start all app services (daemon mode)"
	@echo "  make monitoring-up               - Start all monitoring services (daemon mode)"
	@echo "  make app-down                    - Stop all app containers (keep volumes)"
	@echo "  make monitoring-down             - Stop all monitoring containers (keep volumes)"
	@echo "  make down-v-app                  - Stop all containers app and remove volumes"
	@echo "  make down-v-monitoring           - Stop all monitoring containers and remove volumes"
	@echo "  make compose-config-app          - Validate and view the compose configuration for app"
	@echo "  make compose-config-monitoring   - Validate and view the compose configuration for monitoring"
	@echo "  make ps                          - Show running containers status"
	@echo "  make network-inspect             - Inspect the Docker network details"
	@echo ""
	@echo "Database Management:"
	@echo "  make makemigrations              - Create new database migrations"
	@echo "  make showmigrations              - List all migrations and their status"
	@echo "  make migrate                     - Apply database migrations"
	@echo "  make collectstatic               - Collect static files with cleanup"
	@echo "  make superuser                   - Create a Django superuser"
	@echo "  make db-flush                    - Flush the database"
	@echo "  make db-connect                  - Connect to PostgreSQL database with psql"
	@echo ""
	@echo "Logging & Debugging:"
	@echo "  make backend-log                 - View backend service logs"
	@echo "  make log-all                     - View logs for all services"
	@echo "  make live-log                    - Follow logs for all services (real-time)"
	@echo ""
	@echo "Development Utilities:"
	@echo "  make backend-bash                - Open bash shell in backend container"
	@echo ""
	@echo "Use 'make <command>' to execute any of the above commands"

app-build:
	docker compose -f compose/dev/compose.dev.yml up --build -d --remove-orphans

monitoring-build:
	docker compose -f compose/dev/compose.monitoring.dev.yml up --build -d --remove-orphans

app-up:
	docker compose -f compose/dev/compose.dev.yml up -d

monitoring-up:
	docker compose -f compose/dev/compose.monitoring.dev.yml up -d


app-down:
	docker compose -f compose/dev/compose.dev.yml down

monitoring-down:
	docker compose -f compose/dev/compose.monitoring.dev.yml down

down-v-app:
	docker compose -f compose/dev/compose.dev.yml down -v

down-v-monitoring:
	docker compose -f compose/dev/compose.monitoring.dev.yml down -v

compose-config-app:
	docker compose -f compose/dev/compose.dev.yml config

compose-config-monitoring:
	docker compose -f compose/dev/compose.monitoring.dev.yml config

makemigrations:
	docker compose -f compose/dev/compose.dev.yml run --rm backend python manage.py makemigrations

showmigrations:
	docker compose -f compose/dev/compose.dev.yml run --rm backend python manage.py showmigrations

migrate:
	docker compose -f compose/dev/compose.dev.yml run --rm backend python manage.py migrate

collectstatic:
	docker compose -f compose/dev/compose.dev.yml run --rm backend python manage.py collectstatic --no-input --clear

superuser:
	docker compose -f compose/dev/compose.dev.yml run --rm backend python manage.py createsuperuser

db-flush:
	docker compose -f compose/dev/compose.dev.yml run --rm backend python manage.py flush

network-inspect:
	docker inspect bloggyspace_nw

ps:
	docker compose -f compose/dev/compose.dev.yml ps

backend-log:
	docker compose -f compose/dev/compose.dev.yml logs backend

nginx-log:
	docker compose -f compose/dev/compose.dev.yml logs nginx

backend-bash:
	docker compose -f compose/dev/compose.dev.yml exec backend bash

nginx-bash:
	docker compose -f compose/dev/compose.dev.yml exec nginx sh

log-all:
	docker compose -f compose/dev/compose.dev.yml logs

live-log:
	docker compose -f compose/dev/compose.dev.yml logs -f

db-connect:
	docker compose -f compose/dev/compose.dev.yml exec -it postgres \
	psql -U bloggyspace_dev_user -d bloggyspace_dev_db