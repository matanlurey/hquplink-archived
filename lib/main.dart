import 'package:device_id/device_id.dart';
import 'package:flutter/material.dart';
import 'package:hquplink/models.dart';
import 'package:hquplink/services.dart';

import 'src/app.dart';

void main() async {
  // Use JSON Local Storage.
  const storage = const JsonStorage();
  Roster roster;

  Future<void> loadRoster() async {
    return roster = await storage.loadJson(
      Roster.serializer,
      'roster.json',
      defaultTo: RosterBuilder().build,
    );
  }

  // A hacky way to clear corrupted data, for now.
  //
  // We should propogate the error to the UI so the user has the choice on what
  // to do at this point in time, for example, exporting data before we delete.
  try {
    await loadRoster();
  } on Object catch (_) {
    await storage.deleteJson('roster.json');
    await loadRoster();
  }

  // Load Local Device ID for UUIDs.
  setDeviceId(await DeviceId.getID);

  // Start the application.
  runApp(
    provideCatalog(
      Catalog.builtIn,
      HQUplinkApp(
        enableDeveloperMode: false,
        initialRoster: roster,
      ),
    ),
  );
}
