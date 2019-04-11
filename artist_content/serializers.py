from rest_framework import serializers
from . models import Video

class ArtistVideoSerializer(serializers.ModelSerializer):

    class Meta:

        model = Video
        fields = '__all__'