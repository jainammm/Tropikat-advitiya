import 'package:flutter/material.dart';
import './auth.dart';
import 'package:flutter_auth_buttons/flutter_auth_buttons.dart';

import 'artist/artist.dart';
import 'producer/producer.dart';

class LoginPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => new _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  String selected = '1';
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return MaterialApp(
      home: Scaffold(
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: <Widget>[
                  RaisedButton(
                    color: selected == '1'?Colors.green:Colors.grey,
                      onPressed: () {
                        setState(() {
                          selected = '1';
                        });
                      },
                      child: Text("Artist")),
                  RaisedButton(
                    color: selected == '2'?Colors.green:Colors.grey,
                      onPressed: () {
                        setState(() {
                          selected = '2';
                        });
                        
                      },
                      child: Text("Producer"))
                ],
              ),
              GoogleSignInButton(
                onPressed: () {
                  signIntoFirebase(selected).then((result) {
                    if (result[0] == '1') {
                      Navigator.pushAndRemoveUntil(
                          context,
                          MaterialPageRoute(
                              builder: (context) => ArtistPage(result[1])),
                          (_) => false);
                    }
                    if (result[0] == '2') {
                      Navigator.pushAndRemoveUntil(
                          context,
                          MaterialPageRoute(
                              builder: (context) => ProducerPage(result[1])),
                          (_) => false);
                    }
                  });
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
