import 'package:hquplink/models.dart';
import 'package:hquplink/services.dart';

import '../fakes/fake_roster.dart';
import '../run.dart';

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
    overrideStorage: storage,
  );
}
