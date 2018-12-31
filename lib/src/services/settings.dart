import 'dart:async';

import 'package:meta/meta.dart';
import 'package:shared_preferences/shared_preferences.dart';

@Immutable()
abstract class Settings {
  static Future<Settings> onDevice() async {
    return _SharedPreferencesSettings(await SharedPreferences.getInstance());
  }

  factory Settings.inMemory([Map<String, Object> data]) {
    return _MemorySettings(data ?? {});
  }

  const Settings._();

  /// Clears all persistent storage settings.
  Future<bool> clear();

  /// Returns [key] as a type [T].
  ///
  /// The following types are supported for [T]:
  /// * [bool]
  /// * [double]
  /// * [int]
  /// * [List<String>]
  /// * [String]
  @protected
  T get<T>(String key);

  /// Sets [key] as a [value].
  ///
  /// The following types are supported for [T]:
  /// * [bool]
  /// * [double]
  /// * [int]
  /// * [List<String>]
  /// * [String]
  @protected
  void set<T>(String key, T value);

  /// Returns whether to group units by rank.
  bool get groupByRank => get('group_by_rank') ?? true;
  set groupByRank(bool v) => set('group_by_rank', v);
}

class _SharedPreferencesSettings extends Settings {
  final SharedPreferences _instance;

  const _SharedPreferencesSettings(this._instance) : super._();

  @override
  Future<bool> clear() => _instance.clear();

  @override
  @protected
  T get<T>(String key) {
    switch (T) {
      case bool:
        return _instance.getBool(key) as T;
      case double:
        return _instance.getDouble(key) as T;
      case int:
        return _instance.getInt(key) as T;
      case String:
        return _instance.getString(key) as T;
      default:
        return _instance.getStringList(key) as T;
    }
  }

  @override
  @protected
  void set<T>(String key, T value) {
    switch (T) {
      case bool:
        _instance.setBool(key, value as bool);
        break;
      case double:
        _instance.setDouble(key, value as double);
        break;
      case int:
        _instance.setInt(key, value as int);
        break;
      case String:
        _instance.setString(key, value as String);
        break;
      default:
        _instance.setStringList(key, value as List<String>);
        break;
    }
  }
}

class _MemorySettings extends Settings {
  final Map<String, Object> _data;

  const _MemorySettings(this._data) : super._();

  @override
  Future<bool> clear() async {
    _data.clear();
    return true;
  }

  @override
  @protected
  T get<T>(String key) => _data[key] as T;

  @override
  @protected
  void set<T>(String key, T value) {
    _data[key] = value;
  }
}
