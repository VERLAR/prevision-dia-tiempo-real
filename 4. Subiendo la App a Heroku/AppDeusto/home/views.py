from django.shortcuts import render
from rest_framework.response import Response
from rest_framework import status
from django.http import HttpResponse
from rest_framework.decorators import api_view
import redis
import os


def index(request):
    """ render index.html """
    return render(request, 'index.html')


@api_view(['GET'])
def redis_data(request, name):
    # Redis-server
    r = redis.from_url(os.environ.get("REDIS_URL"))

    if request.method == 'GET':
        data = r.get(name)

        if data is None:
            return Response(status=status.HTTP_404_NOT_FOUND)
        else:
            return HttpResponse(data)
