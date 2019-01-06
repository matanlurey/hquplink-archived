import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:hquplink/services.dart';

import 'src/run.dart';

/// Enables features that are not yet stable for release.
void main() {
  return run(
      auth: Auth(
    firebaseAuth: FirebaseAuth.instance,
    googleSignIn: GoogleSignIn(),
  ));
}
