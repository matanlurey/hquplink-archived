import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:meta/meta.dart';

class Auth {
  final GoogleSignIn _googleSignIn;
  final FirebaseAuth _firebaseAuth;
  final _onUserChanged = StreamController<FirebaseUser>.broadcast();

  GoogleSignInAccount _googleUser;
  FirebaseUser _firebaseUser;

  Auth({
    @required GoogleSignIn googleSignIn,
    @required FirebaseAuth firebaseAuth,
  })  : assert(googleSignIn != null),
        _googleSignIn = googleSignIn,
        assert(firebaseAuth != null),
        _firebaseAuth = firebaseAuth;

  Auth.disabled()
      : _googleSignIn = null,
        _firebaseAuth = null;

  GoogleIdentity get identity => _googleUser;

  bool get isEnabled => _googleSignIn != null;

  bool get isSignedIn => _firebaseUser != null;

  Future<FirebaseUser> signIn() async {
    _googleUser = await _googleSignIn.signIn();
    final googleAuth = await _googleUser.authentication;
    _firebaseUser = await _firebaseAuth.signInWithGoogle(
      accessToken: googleAuth.accessToken,
      idToken: googleAuth.idToken,
    );
    _onUserChanged.add(_firebaseUser);
    return _firebaseUser;
  }

  Future<void> signOut() async {
    await _firebaseAuth.signOut();
    await _googleSignIn.signOut();
    _googleUser = _firebaseUser = null;
    _onUserChanged.add(null);
  }

  Stream<FirebaseUser> get onUserChanged => _onUserChanged.stream;
}
