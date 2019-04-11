from django.contrib import admin
from . models import Video

# Register your models here.

class VideoAdminModel(admin.ModelAdmin):

    list_display = ["title", "id"]

    search_fields = ["title"]

    class Meta:

        model = Video

admin.site.register(Video, VideoAdminModel)