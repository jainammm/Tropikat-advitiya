import 'package:google_sign_in/google_sign_in.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:http/http.dart' as http;
import 'dart:io';
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

final FirebaseAuth _auth = FirebaseAuth.instance;
final GoogleSignIn _googleSignIn = GoogleSignIn();
final api_address = "http://192.168.43.39:8000";

Future<GoogleSignInAccount> getSignedInAccount(
    GoogleSignIn googleSignIn) async {
  // Is the user already signed in?
  GoogleSignInAccount account = googleSignIn.currentUser;
  // Try to sign in the previous user:
  if (account == null) {
    account = await googleSignIn.signInSilently();
  }
  return account;
}

Future<List<String>> signIntoFirebase(type) async {
  GoogleSignInAccount googleSignInAccount = await _googleSignIn.signIn();
  final GoogleSignInAuthentication googleAuth =
      await googleSignInAccount.authentication;

  final AuthCredential credential = GoogleAuthProvider.getCredential(
    accessToken: googleAuth.accessToken,
    idToken: googleAuth.idToken,
  );
  print('object');
  print(googleAuth.idToken);

  SharedPreferences prefs = await SharedPreferences.getInstance();
  prefs.setString("type", type);

  final FirebaseUser user = await _auth.signInWithCredential(credential);
  print(user.email);
  String token = await user.getIdToken();
  var url = api_address+"/account/token-login/?type="+type;
  var client = http.Client();
  print(url);
  var request = http.Request('POST', Uri.parse(url));
  request.headers[HttpHeaders.AUTHORIZATION] = token;
  print("VERIFYING THE TOKEN");
  var response = await client.send(request);
  var responsestr = await response.stream.bytesToString();
  print("printing repsonse stirng");
  print(responsestr);
  var decodeddata = jsonDecode(responsestr);
  if (decodeddata['status']=='pass') {
    return [decodeddata['category'],decodeddata['id']];
  }else return ['3','0'];
}
