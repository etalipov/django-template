makemigrations:
	python manage.py makemigrations

migrate:
	python manage.py migrate

createsuperuser:
	python manage.py createsuperuser --noinput

ruff_fix:
	ruff format .
	ruff check . --fix

mypy:
	mypy .

collectstatic:
	python manage.py collectstatic --noinput