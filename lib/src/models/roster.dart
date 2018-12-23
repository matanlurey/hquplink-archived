import 'package:built_collection/built_collection.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';
import 'package:meta/meta.dart';
import 'package:swlegion/swlegion.dart';

// TODO: Expose the builders for these classes to avoid these imports.
// ignore_for_file: implementation_imports

import 'package:swlegion/src/model/command_card.dart';
import 'package:swlegion/src/model/unit.dart';
import 'package:swlegion/src/model/upgrade.dart';

part 'roster.g.dart';

@SerializersFor([
  Army,
  ArmyUnit,
  AttackDice,
  AttackSurge,
  CommandCard,
  CommandCardKey,
  DefenseDice,
  Faction,
  Keyword,
  Rank,
  Roster,
  UnitType,
  Unit,
  UnitKey,
  Upgrade,
  UpgradeKey,
  UpgradeSlot,
  Weapon,
])
final Serializers rosterSerializers = _$rosterSerializers;

/// Represents a collection of [Army] lists, usually for a device or user.
@Immutable()
abstract class Roster implements Built<Roster, RosterBuilder> {
  static Serializer<Roster> get serializer => _$rosterSerializer;

  factory Roster(void Function(RosterBuilder) build) = _$Roster;
  Roster._();

  /// Army lists.
  BuiltList<Army> get armies;
}

/// Represents a collection of [ArmyUnit]s.
@Immutable()
abstract class Army implements Built<Army, ArmyBuilder> {
  static Serializer<Army> get serializer => _$armySerializer;

  factory Army(void Function(ArmyBuilder) build) = _$Army;
  Army._();

  /// ID of the [Army]. Should use for discrimenating unique armies.
  String get id;

  /// Faction of the [Army].
  Faction get faction;

  /// Maximum point value for the [Army].
  int get maxPoints;

  /// User-defined name of the [Army].
  String get name;

  /// Units.
  BuiltList<ArmyUnit> get units;

  /// Commands.
  BuiltSet<CommandCardKey> get commands;
}

/// Represents a [Unit] and [Upgrade]s.
@Immutable()
abstract class ArmyUnit implements Built<ArmyUnit, ArmyUnitBuilder> {
  static Serializer<ArmyUnit> get serializer => _$armyUnitSerializer;

  factory ArmyUnit(void Function(ArmyUnitBuilder) build) = _$ArmyUnit;
  ArmyUnit._();

  /// ID of the unit. Should use for discrimenating unique army units.
  String get id;

  /// Unit.
  UnitKey get unit;

  /// Upgrades.
  BuiltSet<UpgradeKey> get upgrades;
}
