import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:built_collection/built_collection.dart';
import 'package:built_value/standard_json_plugin.dart';
import 'package:built_value/serializer.dart';
import 'package:hquplink/models.dart';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';
import 'package:swlegion/swlegion.dart';

/// Supports loading and saving JSON documents to disk.
class JsonStorage {
  static final _appDir = getApplicationDocumentsDirectory().then((d) => d.path);
  static final Serializers _jsonSerializer = () {
    final builder = serializers.toBuilder()
      ..add(Roster.serializer)
      ..addBuilderFactory(
        const FullType(BuiltList, [const FullType(Army)]),
        () => ListBuilder<Army>(),
      )
      ..addPlugin(StandardJsonPlugin());
    return builder.build();
  }();

  const JsonStorage();

  static Future<File> _appDirFile(String name) async {
    return File(p.join(await _appDir, name));
  }

  /// Loads a file at [path] and deserialized it to [T] using [serializer].
  Future<T> loadJson<T>(
    Serializer<T> serializer,
    String path, {
    T Function() defaultTo,
  }) async {
    final file = await _appDirFile(path);
    if (!(await file.exists())) {
      return defaultTo();
    }
    final data = await file.readAsString();
    final json = jsonDecode(data) as Object;
    return _jsonSerializer.deserializeWith(serializer, json);
  }

  /// Saves a file at [path] serializing [entity] using [serializer].
  Future<void> saveJson<T>(
    T entity,
    Serializer<T> serializer,
    String path,
  ) async {
    final file = await _appDirFile(path);
    final data = _jsonSerializer.serializeWith(serializer, entity);
    final json = jsonEncode(data);
    return file.writeAsString(json);
  }

  /// Deletes a file at [path].
  Future<void> deleteJson(String path) async => (await _appDirFile(path)).delete(); 
}
