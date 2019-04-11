from rest_framework import viewsets
from . models import Video, Requests_From_Artists_For_Video
from . serializers import ArtistVideoSerializer
from rest_framework.parsers import FormParser, MultiPartParser
from django_filters.rest_framework import DjangoFilterBackend
from rest_framework.filters import SearchFilter
from rest_framework.response import Response
from rest_framework.views import APIView
from account.models import Producer

class ArtistVideoViewSet(viewsets.ModelViewSet):

    queryset = Video.objects.all()
    serializer_class = ArtistVideoSerializer

    parser_classes = (MultiPartParser, FormParser)
    filter_backeneds = (DjangoFilterBackend, SearchFilter)
    filter_fields = ('artist', )
    search_fields = ('artist')

class OneArtistVideoViewSet(APIView):

    def get(self,request):

        artist = request.GET.get('artist')
        videos = Video.objects.all().filter(artist=artist).values('id','artist','video_file','title','description','minimum_expected_price','category')
        return Response(list(videos))

class get_all_producers(APIView):

    def get(self,request):

        # print (list(Producer.objects.all()))
        videoid = request.GET.get('videoid')
        video = Video.objects.get(id=videoid)
        response = []
        for obj in Producer.objects.all():
            sent = False
            if(Requests_From_Artists_For_Video.objects.all().filter(video=video,producer=obj).exists()):
                sent = True
            response.append({'sent':sent,'id':obj.id,'profile__user__email':obj.profile.user.email,'description':obj.description})
        return Response(response)


class get_all_requests(APIView):

    def get(self,request):
        producerid = request.GET.get('id')
        producer = Producer.objects.get(id=producerid)
        reques = Requests_From_Artists_For_Video.objects.all().filter(producer=producer).values('id','video__video_file','video__title','video__description','video__minimum_expected_price','liked')
        # print (list(Video.objects.all()))
        return Response(list(reques))