FROM python:3.12-slim AS devcontainer

ENV PYTHONPATH=
ENV PYTHONUNBUFFERED=1
ENV POETRY_VIRTUALENVS_CREATE=false
ENV DJANGO_SETTINGS_MODULE=config.settings

RUN apt-get update && \
    apt-get install --assume-yes make && \
    apt-get clean

RUN pip install poetry~=1.8.0 --no-cache-dir

FROM devcontainer AS draft

WORKDIR /opt/django

COPY src/pyproject.toml src/poetry.lock ./

RUN poetry install --no-interaction && \
    yes | poetry cache clear --all --no-interaction .

COPY src ./
COPY .env.template ./.env

FROM draft AS release

RUN python manage.py collectstatic --noinput