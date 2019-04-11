from django.db import models
from django.contrib.auth.models import User
# from artist_content.models import Video

# Create your models here.

class Profile(models.Model):

    user = models.OneToOneField(User, on_delete = models.CASCADE)
    is_artist = models.BooleanField(default = False)
    is_producer = models.BooleanField(default = False)	

    def __str__(self):
        return self.user.email

class Producer(models.Model):

    profile = models.OneToOneField(Profile, on_delete = models.CASCADE)
    description = models.TextField(max_length = 500)
    # list_of_dictionaries = models.TextField(blank=True, null=True)

    def __str__(self):
        return self.profile.user.email

    # def update_dict_list(self,dictt):
    #     if self.


class Artist(models.Model):

    profile = models.OneToOneField(Profile, on_delete = models.CASCADE)
    description = models.TextField(max_length = 500)

    def __str__(self):
        return self.profile.user.email