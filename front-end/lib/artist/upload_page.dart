import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';
import 'package:async/async.dart';
import 'package:path/path.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'dart:io';
import 'package:firebase_auth/firebase_auth.dart';


import 'package:vote_india/auth.dart';

class UploadVideo extends StatefulWidget {
  String _id;
  UploadVideo(this._id);
  @override
  _UploadVideoState createState() => _UploadVideoState();
}

class _UploadVideoState extends State<UploadVideo> {
  final GlobalKey<FormState> _formKey = new GlobalKey<FormState>();
  String _catogery = "ho";
  String _title = "";
  String _decription = "";
  String _minprice = "";
  String _videopath;
  String _filename = "No File Selected";

  Future getImage() async {
    var tempImage = await FilePicker.getFilePath(type: FileType.VIDEO);

    setState(() {
      _videopath = tempImage;
      _filename = basename(tempImage);
    });
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
        appBar: AppBar(
          title: Text("Upload Video"),
        ),
        body: Stack(children: <Widget>[
          ListView(children: [
            Form(
              key: _formKey,
              child: Column(children: [
                Padding(
                  padding: EdgeInsets.all(20.0),
                  child: TextFormField(
                      keyboardType: TextInputType.text,
                      onSaved: (String value) {
                        setState(() {
                          _title =value;
                        });
                        
                      },
                      decoration: new InputDecoration(
                          border: OutlineInputBorder(),
                          hintText: 'Horror',
                          labelText: 'Title')),
                ),
                Padding(
                  padding: EdgeInsets.all(20.0),
                  child: TextFormField(
                      keyboardType: TextInputType.text,
                      onSaved: (String value) {
                        setState(() {
                          _decription =value;
                        });
                        
                      },
                      decoration: new InputDecoration(
                          border: OutlineInputBorder(),
                          hintText: 'type..',
                          labelText: 'Description')),
                ),
                Padding(
                  padding: EdgeInsets.all(20.0),
                  child: TextFormField(
                      keyboardType: TextInputType.text,
                      onSaved: (String value) {
                        setState(() {
                          _minprice = value;
                        });
                        
                      },
                      decoration: new InputDecoration(
                          border: OutlineInputBorder(),
                          hintText: '20k',
                          labelText: 'Minimum Expected Price')),
                ),
                DropdownButton<String>(
                  value: _catogery,
                  items: <DropdownMenuItem<String>>[
                    DropdownMenuItem(
                      child: Text('Horror'),
                      value: 'ho',
                    ),
                    DropdownMenuItem(child: Text('Action'), value: 'ac'),
                    DropdownMenuItem(child: Text('Adventure'), value: 'ad'),
                    DropdownMenuItem(child: Text('Romance'), value: 'ro'),
                  ],
                  onChanged: (String value) {
                    setState(() {
                      _catogery = value;
                    });
                  },
                ),
                Padding(
                    padding: EdgeInsets.all(20.0),
                    child: Row(
                      children: <Widget>[
                        RaisedButton(
                          child: Text('Select'),
                          onPressed: () {getImage();},
                        ),
                        Text(_filename)
                      ],
                    )),
                Padding(
                    padding: EdgeInsets.all(20.0),
                    child: Row(
                      children: <Widget>[
                        RaisedButton(
                          color: Colors.blue,
                          child: Text('Upload'),
                          onPressed: () {
                            _uploadVideo(context);
                          },
                        ),
                      ],
                    ))
              ]),
            )
          ])
        ]));
  }

  _uploadVideo(context) async{
    _formKey.currentState.save();
    File _video =File(_videopath);
    var stream =
        new http.ByteStream(DelegatingStream.typed(_video.openRead()));
    var length = await _video.length();
    String url = api_address + "/artist-content/api/artist-video/";
    var request = new http.MultipartRequest("POST", Uri.parse(url));
    var multipartFile = new http.MultipartFile('video_file', stream, length,
        filename: basename(_filename));
    request.fields["title"] = _title;
    request.fields["description"] = _decription;
    request.fields["minimum_expected_price"] = _minprice;
    request.fields["category"] = _catogery;
    request.fields["artist"] =widget._id;
    request.files.add(multipartFile);
    print(request.fields);
    var response = await request.send();
    print(response.statusCode);
    response.stream.transform(utf8.decoder).listen((value) {
      print(value);
    });
    if(response.statusCode==201)
      Navigator.pop(context);
  }
}
