from django.http import HttpResponse
from django.views import View

from api.tasks import sleep


class TestView(View):
    @staticmethod
    def get(request):
        seconds_s = request.GET.get("seconds")
        if seconds_s is None:
            return HttpResponse("Hello, World!")

        try:
            seconds = int(seconds_s)
        except ValueError as e:
            return HttpResponse(e)

        task = sleep.delay(seconds)

        return HttpResponse(f"Task ID {task.id}")


def index(request):
    return HttpResponse("Start page!")
