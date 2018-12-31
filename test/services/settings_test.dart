import 'dart:async';

import 'package:hquplink/services.dart';
import 'package:meta/meta.dart';
import 'package:mockito/mockito.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:test/test.dart';

void main() {
  group('Settings.inMemory', () {
    Map<String, Object> data;

    setUp(() {
      data = {};
    });

    _test(
      getSettings: () => Settings.inMemory(data),
      spyOnKey: (_, key) => data[key],
    );
  });

  group('Settings.onDevice', () {
    Map<String, Object> data;
    SharedPreferences preferences;

    T _thenGet<T>(Invocation i) {
      return data[i.positionalArguments.first as String] as T;
    }

    Future<bool> _thenSet(Invocation i) {
      final key = i.positionalArguments.first as String;
      final value = i.positionalArguments.last as Object;
      data[key] = value;
      return Future.value(true);
    }

    setUp(() {
      data = {};
      preferences = _MockSharedPreferences();

      when(preferences.getBool(any)).thenAnswer(_thenGet);
      when(preferences.setBool(any, any)).thenAnswer(_thenSet);
    });

    _test(
      getSettings: () => Settings.onDevice(preferences),
      spyOnKey: (_, key) => data[key],
    );
  });
}

void _test({
  @required Settings Function() getSettings,
  @required Object Function(Settings, String) spyOnKey,
}) {
  Settings settings;

  setUp(() {
    settings = getSettings();
  });

  test('should read/write to "group_by_rank"', () {
    expect(
      settings.groupByRank,
      isFalse,
      reason: 'Should default to false',
    );

    settings.groupByRank = true;
    expect(
      settings.groupByRank,
      isTrue,
      reason: 'Should be true after being set',
    );

    expect(
      spyOnKey(settings, Settings.keyGroupByRank),
      isTrue,
      reason: 'Underlying data model should be updated',
    );
  });
}

class _MockSharedPreferences extends Mock implements SharedPreferences {}
