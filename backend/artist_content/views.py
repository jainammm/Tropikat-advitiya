from django.shortcuts import render
from . models import Video, Requests_From_Artists_For_Video
from account.models import Producer
from django.http import JsonResponse
from django.views.decorators.csrf import csrf_exempt
from rest_framework.response import Response

# Create your views here.

def request_video(request):

    videoid = request.GET.get('videoid')
    producerid = request.GET.get('producer')
    video = Video.objects.get(id=videoid)
    producer = Producer.objects.get(id=producerid)
    requested_video, created = Requests_From_Artists_For_Video.objects.get_or_create(video=video, producer=producer, liked = False)
    return JsonResponse({'status':'okay'})

# def abc(request):
#     video_dictionary = dict(Video.id)

def like_video(request):
    videoid = request.GET.get('videoid')
    