setup:
	docker-compose run --rm app make setup

build:
	docker-compose -f docker-compose.yml build app

test:
	docker-compose -f docker-compose.yml up --abort-on-container-exit --exit-code-from app

ci:
	docker-compose -f docker-compose.yml up --abort-on-container-exit --exit-code-from app

push:
	docker-compose -f docker-compose.yml push app

dev:
	docker-compose up

compose-down:
	docker-compose down
