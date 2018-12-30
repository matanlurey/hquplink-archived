import 'package:device_id/device_id.dart';
import 'package:flutter/material.dart';
import 'package:hquplink/models.dart';
import 'package:hquplink/services.dart';
import 'package:path_provider/path_provider.dart';

import 'app.dart';

/// Starts the application.
///
/// May optionally provide different settings for executing.
void run({
  String overrideDeviceId,
  JsonStorage overrideStorage,
  Settings overrideSettings,
}) async {
  // Use JSON Local Storage.
  final storage = overrideStorage ??
      JsonStorage.toDisk(
        (await getApplicationDocumentsDirectory()).path,
      );

  // Load Local Device ID for UUIDs.
  setDeviceId(overrideDeviceId ?? await DeviceId.getID);

  // Use local or in-memory settings.
  final settings = overrideSettings ?? await Settings.onDevice();

  // Start the application.
  runApp(
    provideSettings(
      settings,
      provideStorage(
        storage,
        provideCatalog(
          Catalog.builtIn,
          AppShell(
            initialRoster: await _loadRosterOrRecover(storage),
          ),
        ),
      ),
    ),
  );
}

// TODO: Implement a better strategy for data recovery.
Future<Roster> _loadRosterOrRecover(JsonStorage storage) async {
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

  return roster;
}
