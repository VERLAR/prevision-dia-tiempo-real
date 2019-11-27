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
    # TODO
    r = redis.from_url(
        'redis://h:pf73262bbe920a3cc6f8660cd17d8e42a97985a22d4fd7b8785d8aa421ea24b92@ec2-52-200-153-234.compute-1.amazonaws.com:26799')
    # r = redis.from_url(os.environ.get("REDIS_URL"))

    if request.method == 'GET':
        data = r.get(name)

        if data is None:
            return Response(status=status.HTTP_404_NOT_FOUND)
        else:
            return HttpResponse(data)
