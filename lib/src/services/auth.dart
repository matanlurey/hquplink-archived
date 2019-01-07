import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:meta/meta.dart';

/// Represents the authentication _state_ and an interface to sign in/sign out.
abstract class Auth {
  /// No support for authentication.
  static const Auth disabled = _DisabledAuth();

  /// Creates and returns an authentication state.
  static Future<Auth> create({
    GoogleSignIn googleSignIn,
    FirebaseAuth firebaseAuth,
  }) async {
    googleSignIn ??= GoogleSignIn();
    firebaseAuth ??= FirebaseAuth.instance;
    final auth = _FirebaseAuth(googleSignIn, firebaseAuth);
    if (await googleSignIn.isSignedIn()) {
      auth
        .._firebaseUser = await firebaseAuth.currentUser()
        .._googleUser = googleSignIn.currentUser;
    }
    return auth;
  }

  /// Currently signed in user, or `null` if not [isSignedIn].
  AuthUser get current;

  /// Whether authentication is currently enabled.
  bool get isEnabled;

  /// Whether a user is currently signed in.
  bool get isSignedIn;

  /// Presents the user with an option to sign in, updating state if successful.
  Future<void> signIn();

  /// Signs out of any current state.
  Future<void> signOut();

  /// Emits an event whenever the internal state changes.
  ///
  /// **NOTE**: This does not include the initial configuration state.
  Stream<void> get onChanged;
}

class _FirebaseAuth implements Auth {
  final GoogleSignIn _googleSignIn;
  final FirebaseAuth _firebaseAuth;

  FirebaseUser _firebaseUser;
  GoogleIdentity _googleUser;

  _FirebaseAuth(this._googleSignIn, this._firebaseAuth);

  @override
  AuthUser get current {
    if (!isSignedIn) {
      throw StateError('Not signed in');
    }
    return AuthUser(
      displayName: _googleUser.displayName,
      emailAddress: _googleUser.email,
      uniqueId: _firebaseUser.uid,
      photoUrl: _googleUser.photoUrl,
    );
  }

  @override
  final isEnabled = true;

  @override
  get isSignedIn => _firebaseUser != null;

  @override
  signIn() async {
    final googleUser = await _googleSignIn.signIn();
    if (googleUser != null) {
      final account = await googleUser.authentication;
      _googleUser = googleUser;
      _firebaseUser = await _firebaseAuth.signInWithGoogle(
        idToken: account.idToken,
        accessToken: account.accessToken,
      );
    }
  }

  @override
  signOut() async {
    _firebaseUser = _googleUser = null;
    await _firebaseAuth.signOut();
    await _googleSignIn.signOut();
  }

  @override
  Stream<void> get onChanged => _firebaseAuth.onAuthStateChanged;
}

class _DisabledAuth implements Auth {
  const _DisabledAuth();

  @override
  final current = null;

  @override
  final isEnabled = false;

  @override
  final isSignedIn = false;

  @override
  signIn() => Future.error(UnsupportedError('Authentication not enabled'));

  @override
  signOut() => Future.error(UnsupportedError('Authentication not enabled'));

  @override
  final onChanged = const Stream.empty();
}

/// Details of an authenticated user.
class AuthUser {
  /// Display name of the signed in user.
  final String displayName;

  /// Email address of the signed in user.
  final String emailAddress;

  /// Unique ID for the account.
  final String uniqueId;

  /// Photo URL of the signed in user.
  final String photoUrl;

  const AuthUser({
    @required this.displayName,
    @required this.emailAddress,
    @required this.uniqueId,
    @required this.photoUrl,
  })  : assert(displayName != null),
        assert(emailAddress != null),
        assert(uniqueId != null),
        assert(photoUrl != null);
}
