from django.urls import path
from home import views

urlpatterns = [
    path('', views.index, name='index'),
    path('redis_data/<str:name>', views.redis_data, name='redis_data'),
]
