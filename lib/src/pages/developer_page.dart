import 'package:flutter/material.dart';

class DeveloperPage extends StatelessWidget {
  const DeveloperPage();

  @override
  build(_) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Developer'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: ListView(
          children: const [
            Center(
              child: Text('WARNING: These features are not stable'),
            ),
          ],
        ),
      ),
    );
  }
}
