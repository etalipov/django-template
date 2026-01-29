import time

from celery import shared_task


@shared_task
def sleep(seconds: int) -> None:
    time.sleep(seconds)
