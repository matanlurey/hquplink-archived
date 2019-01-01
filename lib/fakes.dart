import 'package:hquplink/models.dart';
import 'package:hquplink/services.dart';
import 'package:package_info/package_info.dart';

import 'src/fakes/fake_roster.dart';
import 'src/run.dart';

export 'src/fakes/fake_roster.dart';

/// Runs the application with a fake (in-memory) dataset for debugging.
void main() async {
  // Create and write the fake roster so "run" executes otherwise e2e code.
  final storage = JsonStorage.toMemory();
  await storage.saveJson(
    fakeRoster,
    Roster.serializer,
    'roster.json',
  );

  return run(
    deviceId: 'F4K3-D3V1C3',
    packageInfo: PackageInfo(
      appName: 'HQ Uplink (Fake)',
      packageName: 'hquplink_fake',
      version: '1.0.0-fake',
      buildNumber: '0',
    ),
    settings: Settings.inMemory(),
    storage: storage,
  );
}
