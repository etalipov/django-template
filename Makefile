RUN := run --rm
DOCKER_COMPOSE ?= docker compose -f docker-compose-dev.yml
DOCKER_COMPOSE_RUN := ${DOCKER_COMPOSE} $(RUN)


build:
	${DOCKER_COMPOSE} build

up:
	${DOCKER_COMPOSE} up

bash:
	${DOCKER_COMPOSE_RUN} django bash

makemigrations:
	${DOCKER_COMPOSE_RUN} django make makemigrations

migrate:
	${DOCKER_COMPOSE_RUN} django make migrate

createsuperuser:
	${DOCKER_COMPOSE_RUN} django make createsuperuser

ruff_fix:
	${DOCKER_COMPOSE_RUN} django make ruff_fix	

mypy:
	${DOCKER_COMPOSE_RUN} django make mypy

prepare: build migrate createsuperuser