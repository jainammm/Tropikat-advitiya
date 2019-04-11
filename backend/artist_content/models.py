from django.db import models
from django.dispatch import receiver
import os
import threading
from account.models import Artist, Producer
from yolovid.eval import run_eval
#from yolovid.eval import predictions_dict


# Create your models here.

class Video(models.Model):

    video_file = models.FileField(upload_to = 'media/video/', max_length=200)
    title = models.CharField(max_length = 30)
    description = models.TextField(max_length = 500)
    minimum_expected_price = models.CharField(max_length = 20)
    artist = models.ForeignKey(
		Artist,
		on_delete=models.CASCADE,
	)
    categories = (
		('ad', 'Adventure'),
        ('ac', 'Action'),
		('ho', 'Horror'),
		('ro', 'Romance'),
	)
    category = models.CharField(max_length = 2, choices = categories)
    dict_vid = models.TextField(blank=True, null=True)

    def update_dict_vid(self,dictd):
        self.dict_vid = str(dictd)

class Requests_From_Artists_For_Video(models.Model):

    liked = models.BooleanField()
    video = models.ForeignKey(
        Video,
        on_delete=models.CASCADE,
    )
    producer = models.ForeignKey(
        Producer,
        on_delete=models.CASCADE
    )

@receiver(models.signals.post_save, sender = Video)
def generate_dictionary(sender, instance, **kwargs):
    vid = str(instance.video_file)
    dictd = run_eval(vid,instance)
    # thread = threading.Thread(target = run_yolo, args=(str(instance.video_file), instance,))
    # thread.start()
    print(instance.video_file)

def run_yolo(vid, instance):
    print(vid)
    dictd = run_eval(vid,instance)
    #instance.update_dict_vid(dictd)
    #print("dilip"+str(predictions_dict))

# class Liked_Videos(models.Model):

#     video = models.ForeignKey(
#         Video,
#         on_delete=models.CASCADE
#     )
#     producer = models.ForeignKey(
#         Producer,
#         on_delete=models.Case)
#     liked = models.BooleanField()