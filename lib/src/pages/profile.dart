import 'package:flutter/material.dart';

import '../services/auth.dart';

class ProfilePage extends StatelessWidget {
  const ProfilePage();

  @override
  build(context) {
    final auth = Auth.of(context);
    if (auth.isSignedIn) {
      return Center(
        child: RaisedButton(
          child: Text('${auth.currentUser.displayName}: Sign Out'),
          onPressed: auth.signOut,
        ),
      );
    }
    return Center(
      child: RaisedButton(
        child: const Text('Sign In with Google'),
        onPressed: () async {
          try {
            await auth.signIn();
          } on Exception catch (e) {
            await showDialog<void>(
              context: context,
              builder: (_) {
                return SimpleDialog(
                  title: const Text('Error'),
                  children: [
                    Text('$e'),
                  ],
                );
              },
            );
          }
        },
      ),
    );
  }
}
