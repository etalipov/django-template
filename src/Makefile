default: test

install:
	poetry install

format_fix:
	poetry run ruff format .

lint_fix:
	poetry run ruff check . --fix

types:
	poetry run mypy .

makemigrations:
	poetry run python manage.py makemigrations

migrate:
	poetry run python manage.py migrate

collectstatic:
	poetry run python manage.py collectstatic --noinput

createsuperuser:
	poetry run python manage.py createsuperuser --noinput
