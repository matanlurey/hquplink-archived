import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:hquplink/services.dart';

import 'src/run.dart';

/// Enables features that are not yet stable for release.
void main() async {
  return run(
    auth: await Auth.create(
      firebaseAuth: FirebaseAuth.instance,
      googleSignIn: GoogleSignIn(),
    ),
  );
}
