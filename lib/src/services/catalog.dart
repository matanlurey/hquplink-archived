import 'package:hquplink/models.dart';
import 'package:meta/meta.dart';
import 'package:swlegion/database.dart' as aggregate;

import 'unique_ids.dart';

/// Returns [elements] indexed as a `Map: Reference<E> -> E`.
Map<Reference<E>, E> indexEntities<E extends Indexable<E>>(
  Iterable<E> elements,
) {
  final results = <Reference<E>, E>{};
  for (final e in elements) {
    results[e.toRef()] = e;
  }
  return Map.unmodifiable(results);
}

/// Data model for Star Wars: Legion.
///
/// Binds to the model and data from `package:swlegion`, and provides additional
/// functionality for the application such as validation, filtering, and more.
class Catalog {
  /// Catalog that is built-in to this package (not downloaded).
  static final builtIn = Catalog(
    commands: aggregate.commands,
    units: aggregate.units,
    upgrades: aggregate.upgrades,
  );

  /// Returns whether [a] is null _or_ whether `a == b`.
  static bool _nullOrEqual<T>(T a, T b) {
    return a == null || a == b;
  }

  final Map<Reference<CommandCard>, CommandCard> _commands;
  final Map<Reference<Unit>, Unit> _units;
  final Map<Reference<Upgrade>, Upgrade> _upgrades;

  Catalog({
    @required Iterable<CommandCard> commands,
    @required Iterable<Unit> units,
    @required Iterable<Upgrade> upgrades,
  })  : _commands = indexEntities(commands),
        _units = indexEntities(units),
        _upgrades = indexEntities(upgrades);

  /// Units in the database.
  Iterable<Unit> get units => _units.values;

  /// Upgrades in the database.
  Iterable<Upgrade> get upgrades => _upgrades.values;

  /// Returns a new empty [ArmyBuilder].
  ///
  /// * [ArmyBuilder.id] is assigned a local unique ID.
  /// * [ArmyBuilder.maxPoints] is preset to [maxPoints] (`800` if omitted).
  ArmyBuilder createArmy({
    int maxPoints = 800,
  }) {
    return ArmyBuilder()
      ..maxPoints = maxPoints
      ..id = generateLocalId();
  }

  /// Returns a new empty [ArmyUnitBuilder].
  ///
  /// * [ArmyUnitBuilder.id] is assigned a local unique ID.
  ArmyUnitBuilder createArmyUnit() {
    return ArmyUnitBuilder()..id = generateLocalId();
  }

  /// Returns the [CommandCard] for the cooresponding [key].
  CommandCard lookupCommand(Reference<CommandCard> key) => _commands[key];

  /// Returns the [Unit] for the cooresponding [key].
  Unit lookupUnit(Reference<Unit> key) => _units[key];

  /// Returns the [Upgrade] for the cooresponding [key].
  Upgrade lookupUpgrade(Reference<Upgrade> key) => _upgrades[key];

  /// Returns the sum of all points in the provided [army].
  int sumArmyPoints(Army army) {
    return army.units.fold(0, (p, u) => p + sumUnitPoints(u));
  }

  /// Returns the sum of all points in the provided [armyUnit].
  int sumUnitPoints(ArmyUnit armyUnit) {
    final unit = lookupUnit(armyUnit.unit);
    final upgrades = armyUnit.upgrades.map(lookupUpgrade);
    return upgrades.fold(unit.points, (p, u) => p + u.points);
  }

  /// Returns the sum of all miniatures in the provided [armyUnit].
  int sumMiniatures(ArmyUnit armyUnit) {
    return armyUnit.upgrades.map(lookupUpgrade).fold(
        lookupUnit(armyUnit.unit).miniatures,
        (p, u) => p + (u.addsMiniature ? 1 : 0));
  }

  /// Returns [Unit]s that can be added to [army].
  Iterable<Unit> unitsForArmy(Army army) {
    final inArmy = army.units.map((u) => u.unit).toSet();
    return units.where((unit) {
      if (unit.isUnique && inArmy.contains(unit.toRef())) {
        return false;
      }
      return unit.faction == army.faction;
    });
  }

  /// Returns [Upgrade]s that can be added to a [slot].
  ///
  /// Optionally will further filter by upgrades that are valid for [unit].
  Iterable<Upgrade> upgradesForSlot(UpgradeSlot slot, {Unit unit}) {
    return upgrades.where((u) {
      if (u.type != slot) {
        return false;
      }
      if (unit == null) {
        return true;
      }
      if (!_nullOrEqual(u.restrictedToFaction, unit.faction)) {
        return false;
      }
      return u.restrictedToUnit.isEmpty ||
          u.restrictedToUnit.contains(unit.toRef());
    });
  }

  /// Returns [Upgrade]s that can be added to a [unit].
  ///
  /// This skips upgrades that could be _normally_ added, but cannot currently
  /// due to that upgrade already being added or no valid slots of that upgrade
  /// type being available.
  Iterable<Upgrade> upgradesForUnit(ArmyUnit unit) {
    final details = lookupUnit(unit.unit);
    final upgradeSlots = details.upgrades;
    final availableSlots = upgradeSlots.toMap();
    for (final upgrade in unit.upgrades.map(lookupUpgrade)) {
      final value = availableSlots[upgrade.type];
      if (value != null) {
        availableSlots[upgrade.type] = value - 1;
      }
    }
    return upgrades.where((u) {
      if ((availableSlots[u.type] ?? 0) < 1) {
        return false;
      }
      if (u.restrictedToUnit.isNotEmpty &&
          !u.restrictedToUnit.contains(unit.unit)) {
        return false;
      }
      return _nullOrEqual(u.restrictedToFaction, details.faction);
    });
  }
}
