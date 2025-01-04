RUN := run --rm
DOCKER_COMPOSE ?= docker compose
DOCKER_COMPOSE_RUN := ${DOCKER_COMPOSE} $(RUN)

default: prepare

build:
	${DOCKER_COMPOSE} build

bash:
	${DOCKER_COMPOSE_RUN} django bash

install:
	${DOCKER_COMPOSE_RUN} django make install

makemigrations:
	${DOCKER_COMPOSE_RUN} django make makemigrations

migrate:
	${DOCKER_COMPOSE_RUN} django make migrate

createsuperuser:
	${DOCKER_COMPOSE_RUN} django make createsuperuser

lint:
	${DOCKER_COMPOSE_RUN} django make format_fix
	${DOCKER_COMPOSE_RUN} django make lint_fix

types:
	${DOCKER_COMPOSE_RUN} django make types

up:
	${DOCKER_COMPOSE} up

prepare: build install migrate createsuperuser