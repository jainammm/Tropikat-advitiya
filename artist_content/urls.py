"""advitiya_hackathon_2019 URL Configuration

The `urlpatterns` list routes URLs to views. For more information please see:
    https://docs.djangoproject.com/en/2.1/topics/http/urls/
Examples:
Function views
    1. Add an import:  from my_app import views
    2. Add a URL to urlpatterns:  path('', views.home, name='home')
Class-based views
    1. Add an import:  from other_app.views import Home
    2. Add a URL to urlpatterns:  path('', Home.as_view(), name='home')
Including another URLconf
    1. Import the include() function: from django.urls import include, path
    2. Add a URL to urlpatterns:  path('blog/', include('blog.urls'))
"""
from django.contrib import admin
from django.urls import path, include
from rest_framework.routers import DefaultRouter
from .api import ArtistVideoViewSet, OneArtistVideoViewSet, get_all_producers, get_all_requests
from .views import request_video

router = DefaultRouter()
router.register('artist-video', ArtistVideoViewSet)


urlpatterns = [
    path('api/', include(router.urls)),
    path('one-artist-video/', OneArtistVideoViewSet.as_view()),
    path('request-video/', request_video),
    path('get-all-producers/', get_all_producers.as_view()),
    path('get-all-requests/',get_all_requests.as_view()),
]
