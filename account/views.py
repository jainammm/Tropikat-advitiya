from django.http import HttpResponse, JsonResponse
from django.views.decorators.csrf import csrf_exempt
from django.contrib.auth.models import User
from django.shortcuts import render
from account.models import Profile, Artist, Producer

# Google AUTH
import firebase_admin
from firebase_admin import credentials
from firebase_admin import auth

@csrf_exempt
def tokenAuth(request):

    if request.method == 'POST':

        token = request.META['HTTP_AUTHORIZATION']

        decoded_token = auth.verify_id_token(token)
        uid = decoded_token['uid']
        user = auth.get_user(uid)

        django_user, created = User.objects.get_or_create(email = user.email, defaults = {
            'username': uid,
            'password': 'iitropar',
        })

        print(user.email)

        category = request.GET.get('type')

        print (category)

        id = 0

        if category != None:

            profile, created = Profile.objects.get_or_create(user=django_user)

            if category == '1': # artist

                artist, created = Artist.objects.get_or_create(profile=profile)
                id = artist.id

            elif category == '2': # producer

                producer, created = Producer.objects.get_or_create(profile=profile)
                id = producer.id

            return JsonResponse({'category':category, 'status':'pass', 'id':str(id)})

        return JsonResponse({'status':'fail'})

    return HttpResponse("Sucess")
