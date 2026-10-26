.PHONY: up down ps logs migrate test-solver test-core

up:
	docker compose up -d --build --wait

down:
	docker compose down -v

ps:
	docker compose ps

logs:
	docker compose logs -f --tail=100

migrate:
	docker compose run --rm flyway migrate

test-solver:
	cd services/solver-svc && pytest -v

test-core:
	cd services/core-api && gradle test --no-daemon
