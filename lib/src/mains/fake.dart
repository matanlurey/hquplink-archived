import 'package:hquplink/models.dart';
import 'package:hquplink/services.dart';

import '../fakes/fake_roster.dart';
import 'run.dart';

void main() async {
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
