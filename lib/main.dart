import 'package:flutter/material.dart';
import 'package:hquplink/models.dart';
import 'package:hquplink/services.dart';

import 'src/app.dart';

void main() async {
  const storage = const JsonStorage();
  runApp(
    HQUplinkApp(
      enableDeveloperMode: false,
      initialRoster: await storage.load(
        Roster.serializer,
        'roster.json',
        defaultTo: RosterBuilder().build,
      ),
    ),
  );
}
