// ignore_for_file: parameter_assignments

import 'package:device_id/device_id.dart';
import 'package:flutter/material.dart';
import 'package:hquplink/models.dart';
import 'package:hquplink/services.dart';
import 'package:package_info/package_info.dart';
import 'package:path_provider/path_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'app.dart';

Future<T> _resolve<T>(T resultOrNull, Future<T> Function() getResult) {
  if (resultOrNull != null) {
    return Future.value(resultOrNull);
  }
  return getResult();
}

/// Starts the application.
///
/// May optionally provide different settings for executing.
void run({
  bool debugMode,
  String deviceId,
  PackageInfo packageInfo,
  JsonStorage storage,
  Settings settings,
}) async {
  // If debugMode not overriden, determine based on whether asserts are enabled.
  if (debugMode == null) {
    debugMode = false;
    assert(debugMode = true);
  }

  // Resolve missing service classes in parallel as much as possible.
  await Future.wait(<Future<Object>>[
    _resolve(deviceId, () => DeviceId.getID),
    _resolve(packageInfo, PackageInfo.fromPlatform),
    _resolve(storage, () async {
      return JsonStorage.toDisk(
        (await getApplicationDocumentsDirectory()).path,
      );
    }),
    _resolve(settings, () async {
      return Settings.onDevice(
        await SharedPreferences.getInstance(),
      );
    }),
  ], eagerError: true)
      .then((results) {
    setDeviceId(results[0] as String);
    packageInfo = results[1] as PackageInfo;
    storage = results[2] as JsonStorage;
    settings = results[3] as Settings;
  });

  // Start the application.
  var appVersion = packageInfo.version;
  if (debugMode) {
    appVersion = 'DEBUG: $appVersion';
  } else if (packageInfo.buildNumber.isNotEmpty) {
    appVersion = '$appVersion (Build ${packageInfo.buildNumber})';
  }

  runApp(
    provideSettings(
      settings,
      provideStorage(
        storage,
        provideCatalog(
          Catalog.builtIn,
          AppShell(
            appVersion: appVersion,
            initialRoster: await _loadRosterOrRecover(storage),
            onRosterUpdated: (roster) async {
              await storage.saveJson(
                roster,
                Roster.serializer,
                'roster.json',
              );
            },
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
