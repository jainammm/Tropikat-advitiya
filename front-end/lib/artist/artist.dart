import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:video_player/video_player.dart';

import 'upload_page.dart';
import 'package:vote_india/auth.dart';

class ArtistPage extends StatefulWidget {
  String id;
  ArtistPage(this.id);
  @override
  _ArtistPage createState() => _ArtistPage();
}

class _ArtistPage extends State<ArtistPage> {
  Widget _buildContent() {
    return FutureBuilder(
      future: _getdatafromserver(),
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          var jsondata = jsonDecode(snapshot.data.toString());
          if (jsondata.length > 0) {
            return Expanded(
                child: ListView.builder(
              itemCount: jsondata.length,
              itemBuilder: (context, index) {
                return Card(
                  margin: EdgeInsets.all(10.0),
                  child: InkWell(
                    onTap: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => VideoApp(
                                  api_address +
                                      "/video/" +
                                      jsondata[index]['video_file'],
                                  jsondata[index]['title'],
                                  jsondata[index]['description'],
                                  (jsondata[index]['id']).toString())));
                    },
                    child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: <Widget>[
                          Text(
                            jsondata[index]['title'],
                            style: TextStyle(
                                fontSize: 30.0, fontWeight: FontWeight.bold),
                          ),
                          Text(jsondata[index]['minimum_expected_price'])
                        ]),
                  ),
                );
              },
            ));
          }
          else
          return Center(
            child: Text('no data'));
        } else
          return Center(
            child: Text('error'),
          );
      },
    );
  }

  Center _buildLoadingIndicator() {
    return Center(
      child: new CircularProgressIndicator(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: _Drawer(),
      appBar: AppBar(
        title: Text("Artist"),
        actions: <Widget>[
          InkWell(
              onTap: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (BuildContext context) =>
                            UploadVideo(widget.id)));
              },
              child: Icon(Icons.file_upload)),
          Padding(
            padding: EdgeInsets.only(right: 15.0),
          )
        ],
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[_buildContent()],
        ),
      ),
    );
  }

  Future _getdatafromserver() async {
    var url =
        api_address + "/artist-content/one-artist-video/?artist=" + widget.id;
    var client = http.Client();
    print(url);
    var request = http.Request('GET', Uri.parse(url));
    var response = await client.send(request);
    var responsestr = await response.stream.bytesToString();
    print("printing repsonse stirng");
    print(responsestr);
    return responsestr;
  }
}

class _Drawer extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _DrawerState();
}

class _DrawerState extends State<_Drawer> {
  Future<FirebaseUser> getuser() async {
    final FirebaseAuth _auth = FirebaseAuth.instance;
    FirebaseUser user = await _auth.currentUser();
    return user;
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: getuser(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            FirebaseUser user = snapshot.data;
            return Drawer(
                child: ListView(
              children: <Widget>[
                UserAccountsDrawerHeader(
                  accountName: Text(user.displayName),
                  accountEmail: Text(user.email),
                  currentAccountPicture: CircleAvatar(
                    backgroundImage: NetworkImage(user.photoUrl),
                  ),
                ),
                ListTile(
                  title: Text("Ttem 1"),
                  trailing: Icon(Icons.arrow_forward),
                ),
                ListTile(
                  title: Text("Item 2"),
                  trailing: Icon(Icons.arrow_forward),
                ),
              ],
            ));
          } else
            return Center(
              child: CircularProgressIndicator(),
            );
        });
  }
}

class VideoApp extends StatefulWidget {
  final String url;
  final String title;
  final String text;
  final String id;
  VideoApp(this.url, this.title, this.text,this.id);
  @override
  _VideoAppState createState() => _VideoAppState();
}

class _VideoAppState extends State<VideoApp> {
  VideoPlayerController _controller;

  @override
  void initState() {
    super.initState();
    _controller = VideoPlayerController.network(widget.url)
      ..initialize().then((_) {
        // Ensure the first frame is shown after the video is initialized, even before the play button has been pressed.
        setState(() {});
      });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: ListView(children: [
        Column(children: [
          _controller.value.initialized
              ? AspectRatio(
                  aspectRatio: _controller.value.aspectRatio,
                  child: VideoPlayer(_controller),
                )
              : Container(),
          Text(
            "Discriprion:",
            style: TextStyle(fontSize: 20.0),
          ),
          Text(widget.text),
          RaisedButton(
            child: Text("Request"),
            onPressed: (){
              Navigator.push(context, MaterialPageRoute(builder: (context)=>RequestPage(widget.id)));
            }  ,
          ),
          
        ])
      ]),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          setState(() {
            _controller.value.isPlaying
                ? _controller.pause()
                : _controller.play();
          });
        },
        child: Icon(
          _controller.value.isPlaying ? Icons.pause : Icons.play_arrow,
        ),
      ),
    );
  }

  @override
  void dispose() {
    super.dispose();
    _controller.dispose();
  }

  
}

class RequestPage extends StatefulWidget {
  final String id;
  RequestPage(this.id);
  @override
  _RequestPage createState() => _RequestPage();
}

class _RequestPage extends State<RequestPage> {
  bool sent = false;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Select Producers"),),
      body: FutureBuilder(
            future: _getproducers(widget.id),
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                var jsondata = jsonDecode(snapshot.data.toString());
                if (jsondata.length > 0) {
                  return ListView.builder(
                          itemCount: jsondata.length,
                          itemBuilder: (context, index) {
                            sent = jsondata[index]['sent'];
                            return Card(
                              margin: EdgeInsets.all(10.0),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                children: <Widget>[
                                Text(jsondata[index]['profile__user__email']),
                                InkWell(
                                  child: RaisedButton(
                                    color: sent?Colors.red:Colors.grey,
                                    onPressed: (){
                                      _requestToProducer(widget.id,jsondata[index]['id'].toString());
                                      setState(() {
                                       sent = !sent; 
                                      });
                                    },
                                    child: Icon(Icons.send),
                                  ),
                                )
                              ]),
                            );
                          });
                } else
                  return Text('none');
              } else
                return Text('error');
            },
          ),
    );
  }

  Future _requestToProducer(videoid,producerid)async{
    print(videoid+"bb"+producerid);
    var url = api_address + "/artist-content/request-video/?videoid="+videoid+
      "&producer="+producerid;
    var client = http.Client();
    print(url);
    var request = http.Request('GET', Uri.parse(url));
    var response = await client.send(request);
    var responsestr = await response.stream.bytesToString();
    print("printing repsonse stirng");
    print(responsestr);
    return responsestr;
  }

  Future _getproducers(videoid) async {
    var url = api_address + "/artist-content/get-all-producers/?videoid="+videoid;
    var client = http.Client();
    print(url);
    var request = http.Request('GET', Uri.parse(url));
    var response = await client.send(request);
    var responsestr = await response.stream.bytesToString();
    print("printing repsonse stirng");
    print(responsestr);
    return responsestr;
  }
}


