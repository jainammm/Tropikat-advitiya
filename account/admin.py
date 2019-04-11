from django.contrib import admin
from .models import Profile, Artist, Producer
# Register your models here.

class ProfileAdminModel(admin.ModelAdmin):

    list_display = ["user", "id"]

    search_fields = ["user", "user.email"]

    class Meta:

        model = Profile

class ArtistAdminModel(admin.ModelAdmin):

    list_display = ["profile", "id"]

    search_fields = ["profile", "profile.user.email"]

    class Meta:

        model = Artist

class ProducerAdminModel(admin.ModelAdmin):

    list_display = ["profile", "id"]

    search_fields = ["profile", "profile.user.email"]

    class Meta:

        model = Producer

admin.site.register(Profile, ProfileAdminModel)
admin.site.register(Artist, ArtistAdminModel)
admin.site.register(Producer, ProducerAdminModel)