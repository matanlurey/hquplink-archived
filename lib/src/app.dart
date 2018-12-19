import 'package:flutter/material.dart';

class HQUplinkApp extends StatelessWidget {
  const HQUplinkApp();

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'HQ Uplink',
      theme: ThemeData.dark().copyWith(
        primaryColor: Colors.blueGrey.shade800,
        accentColor: Colors.blueGrey.shade400,
      ),
      home: Scaffold(
        appBar: AppBar(
          title: const Text('HQ Uplink'),
        ),
        floatingActionButton: FloatingActionButton(
          child: const Icon(Icons.add, color: Colors.white),
          onPressed: () {
            
          },
        ),
      ),
      debugShowCheckedModeBanner: false,
    );
  }
}
