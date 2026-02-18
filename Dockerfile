FROM python:3.13-slim AS draft

ENV PYTHONUNBUFFERED=1
#   Using system python, without venv
ENV UV_PROJECT_ENVIRONMENT="/usr/local/"    
ENV DJANGO_SETTINGS_MODULE=config.settings

WORKDIR /opt/django

COPY src/pyproject.toml src/uv.lock ./

RUN apt-get update && \
    apt-get install -y make --no-install-recommends && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*
    
COPY --from=ghcr.io/astral-sh/uv:0.9.25 /uv /uvx /bin/

FROM draft AS dev

RUN uv sync --locked --no-install-project

COPY src ./

USER 1001:1001

FROM draft AS release

RUN uv sync --locked --no-install-project --no-dev

COPY src ./

USER 1001:1001
