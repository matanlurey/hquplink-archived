import 'dart:convert';
import 'dart:io';

import 'package:hquplink/fakes.dart';
import 'package:hquplink/models.dart';
import 'package:hquplink/services.dart';
import 'package:meta/meta.dart';
import 'package:path/path.dart' as p;
import 'package:test/test.dart';

void main() {
  Object _fakeRosterSerialized;

  setUpAll(() {
    _fakeRosterSerialized = jsonSerializer.serializeWith(
      Roster.serializer,
      fakeRoster,
    );
  });

  group('JsonStorage.toDisk', () {
    Directory testAppDir;

    setUp(() async {
      testAppDir = await Directory.systemTemp.createTemp();
      final rosterDotJson = File(
        p.join(testAppDir.path, _rosterThatExists),
      );
      await rosterDotJson.writeAsString(
        jsonEncode(_fakeRosterSerialized),
      );
    });

    tearDown(() => testAppDir.delete(recursive: true));

    _test(
        getStorage: () => JsonStorage.toDisk(testAppDir.path),
        spyOnPath: (path) async {
          final file = File(p.join(testAppDir.path, path));
          if (await file.exists()) {
            return file.readAsString();
          } else {
            return null;
          }
        });
  });
  group('JsonStorage.toMemory', () {
    Map<String, Object> data;

    setUp(() {
      data = {
        _rosterThatExists: _fakeRosterSerialized,
      };
    });

    _test(
      getStorage: () => JsonStorage.toMemory(data),
      spyOnPath: (path) {
        final json = data[path];
        return json == null ? Future.value() : Future.value(jsonEncode(json));
      },
    );
  });
}

const _rosterThatExists = 'roster.json';
const _rosterToCreate = 'roster-new.json';
const _rosterThatDoesNotExist = 'roster-missing.json';

// We use "null" to signify a missing file in these tests.
const _fileDoesNotExist = isNull;

void _test({
  @required JsonStorage Function() getStorage,
  @required Future<String> Function(String) spyOnPath,
}) {
  JsonStorage storage;

  setUp(() {
    storage = getStorage();
  });

  test('should load JSON', () async {
    expect(
      await storage.loadJson(
        Roster.serializer,
        _rosterThatExists,
      ),
      fakeRoster,
    );
  });

  test('should fail to load JSON and default to content if missing', () async {
    expect(
      await storage.loadJson(
        Roster.serializer,
        _rosterThatDoesNotExist,
        defaultTo: () => fakeRoster,
      ),
      fakeRoster,
    );
  });

  test('should fail to load JSON and throw', () async {
    expect(
      storage.loadJson(
        Roster.serializer,
        _rosterThatDoesNotExist,
      ),
      throwsArgumentError,
    );
  });

  test('should save JSON', () async {
    expect(
      await spyOnPath(_rosterToCreate),
      _fileDoesNotExist,
    );

    await storage.saveJson(
      fakeRoster,
      Roster.serializer,
      _rosterToCreate,
    );

    expect(
      await storage.loadJson(
        Roster.serializer,
        _rosterToCreate,
      ),
      fakeRoster,
    );
  });

  test('should delete JSON', () async {
    expect(
      await storage.loadJson(
        Roster.serializer,
        _rosterThatExists,
      ),
      isNot(_fileDoesNotExist),
    );

    await storage.deleteJson(_rosterThatExists);

    expect(
      await spyOnPath(_rosterThatExists),
      _fileDoesNotExist,
    );
  });
}
