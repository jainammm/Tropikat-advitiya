import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'login.dart';
import 'auth.dart';
import 'artist/artist.dart';
import 'producer/producer.dart';

Widget _defaulthome;

void main() async {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  FirebaseUser user = await _auth.currentUser();
  _defaulthome = LoginPage();
  if (user != null) {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String type = prefs.getString("type");
    var ud = await signIntoFirebase(type);
    if (ud[0] == '1')
      _defaulthome = ArtistPage(ud[1]);
    else if (ud[0] == '2') _defaulthome = ProducerPage(ud[1]);
  }
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: _defaulthome,
      routes: {
        "login-page": (context) => LoginPage(),
      },
    );
  }
}
