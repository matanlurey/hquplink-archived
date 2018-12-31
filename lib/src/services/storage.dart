import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:built_collection/built_collection.dart';
import 'package:built_value/standard_json_plugin.dart';
import 'package:built_value/serializer.dart';
import 'package:hquplink/models.dart';
import 'package:meta/meta.dart';
import 'package:path/path.dart' as p;

/// JSON [Serializers] for this
@visibleForTesting
final Serializers jsonSerializer = () {
  final builder = rosterSerializers.toBuilder()
    ..add(Roster.serializer)
    ..addBuilderFactory(
      const FullType(BuiltList, [const FullType(Army)]),
      () => ListBuilder<Army>(),
    )
    ..addPlugin(StandardJsonPlugin());
  return builder.build();
}();

abstract class JsonStorage {
  const JsonStorage._();

  factory JsonStorage.toDisk(String localPath) {
    return _DiskJsonStorage(localPath);
  }

  factory JsonStorage.toMemory([Map<String, Object> store]) {
    return _MemoryJsonStorage(store ?? {});
  }

  /// Loads a file at [path] and deserialized it to [T] using [serializer].
  Future<T> loadJson<T>(
    Serializer<T> serializer,
    String path, {
    T Function() defaultTo,
  }) async {
    if (defaultTo == null) {
      throw ArgumentError('No storage specified, and "defaultTo" was omitted.');
    }
    return defaultTo();
  }

  /// Saves a file at [path] serializing [entity] using [serializer].
  Future<void> saveJson<T>(
    T entity,
    Serializer<T> serializer,
    String path,
  );

  /// Deletes a file at [path].
  Future<void> deleteJson(String path);
}

class _MemoryJsonStorage extends JsonStorage {
  final Map<String, Object> _backingMap;

  const _MemoryJsonStorage(this._backingMap) : super._();

  @override
  Future<T> loadJson<T>(
    Serializer<T> serializer,
    String path, {
    T Function() defaultTo,
  }) async {
    final json = _backingMap[path];
    if (json == null) {
      return super.loadJson(serializer, path, defaultTo: defaultTo);
    }
    return jsonSerializer.deserializeWith(serializer, json);
  }

  @override
  Future<void> saveJson<T>(
    T entity,
    Serializer<T> serializer,
    String path,
  ) async {
    _backingMap[path] = jsonSerializer.serializeWith(serializer, entity);
  }

  @override
  Future<void> deleteJson(String path) async => _backingMap.remove(path);
}

/// Supports loading and saving JSON documents to disk.
class _DiskJsonStorage extends JsonStorage {
  final String path;

  const _DiskJsonStorage(this.path) : super._();

  @override
  bool operator ==(Object o) => o is _DiskJsonStorage && o.path == path;

  @override
  int get hashCode => path.hashCode;

  @override
  Future<T> loadJson<T>(
    Serializer<T> serializer,
    String path, {
    T Function() defaultTo,
  }) async {
    final file = File(p.join(this.path, path));
    if (!await file.exists()) {
      return super.loadJson(
        serializer,
        path,
        defaultTo: defaultTo,
      );
    }
    final data = await file.readAsString();
    final json = jsonDecode(data) as Object;
    return jsonSerializer.deserializeWith(serializer, json);
  }

  @override
  Future<void> saveJson<T>(
    T entity,
    Serializer<T> serializer,
    String path,
  ) async {
    final file = File(p.join(this.path, path));
    final data = jsonSerializer.serializeWith(serializer, entity);
    final json = jsonEncode(data);
    return file.writeAsString(json);
  }

  @override
  Future<void> deleteJson(String path) {
    return File(p.join(this.path, path)).delete();
  }
}
