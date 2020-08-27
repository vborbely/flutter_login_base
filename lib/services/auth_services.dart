import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';

class AuthServices {
  FirebaseAuth _auth = FirebaseAuth.instance;
  User _user;
  User get user => _user;
  StreamController<User> _streamController = StreamController.broadcast();
  Stream<User> get authStream => _streamController.stream;
  GoogleSignIn _googleSignIn = GoogleSignIn();
  String get googleId => _googleSignIn.clientId;


  Future<User> loginWithGoogle() async {
    GoogleSignInAccount googleSignInAccount = await _googleSignIn.signIn();
    GoogleSignInAuthentication googleSignInAuthentication = await googleSignInAccount.authentication;

    AuthCredential credential = GoogleAuthProvider.credential(
        idToken: googleSignInAuthentication.idToken, accessToken: googleSignInAuthentication.accessToken);
    _user = (await _auth.signInWithCredential(credential)).user;
    _streamController.add(_user);
    return _user;
  }

  Future<void> logoutWithGoogle() async {
    _auth.signOut().then((value) {
      _googleSignIn.signOut();
      _user = null;
      _streamController.add(_user);
    });
  }
}
