import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/widgets.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:meta/meta.dart';

/// Authentication service and state.
class Auth {
  /// Returns the currently provided [Auth] given a build [context].
  static Auth of(BuildContext context) {
    final model = context.inheritFromWidgetOfExactType(AuthModel);
    if (model is AuthModel) {
      return model.auth;
    }
    throw StateError('No provider found for $Auth.');
  }

  /// Updated authentication state, often for the initial state.
  static Stream<Auth> get onUpdate async* {
    await for (final newUser in FirebaseAuth.instance.onAuthStateChanged) {
      yield Auth(currentUser: newUser);
    }
  }

  /// Currently authenticated user, or `null` if not [isSignedIn].
  final FirebaseUser currentUser;

  const Auth({
    this.currentUser,
  });

  @override
  bool operator ==(Object o) => o is Auth && currentUser == o.currentUser;

  @override
  int get hashCode => currentUser.hashCode;

  /// Whether currently authenticated.
  bool get isSignedIn => currentUser != null;

  static final _googleSignIn = GoogleSignIn();

  /// Sign in to the application.
  Future<void> signIn() async {
    final authWithGoogle = await (await _googleSignIn.signIn())?.authentication;
    if (authWithGoogle != null) {
      final result = await FirebaseAuth.instance.signInWithGoogle(
        accessToken: authWithGoogle.accessToken,
        idToken: authWithGoogle.idToken,
      );
      print(result.displayName);
    }
  }

  /// Sign out of the application.
  Future<void> signOut() async {
    await FirebaseAuth.instance.signOut();
    await _googleSignIn.signOut();
  }
}

/// An [InheritedModel] that provides access to the [Auth].
class AuthModel extends InheritedModel<Auth> {
  /// Authentication state.
  final Auth auth;

  const AuthModel({
    @required this.auth,
    Widget child,
  })  : assert(auth != null),
        super(child: child);

  @override
  bool updateShouldNotify(AuthModel old) => old.auth != auth;

  @override
  bool updateShouldNotifyDependent(
    AuthModel old,
    Set<Auth> dependencies,
  ) {
    return updateShouldNotify(old) && dependencies.contains(auth);
  }
}
