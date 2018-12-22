import 'package:meta/meta.dart';
import 'package:swlegion/database.dart' as aggregate;
import 'package:swlegion/swlegion.dart';

import 'unique_ids.dart';

class Catalog {
  static bool _nullOrEqual<T>(T a, T b) {
    return a == null || a == b;
  }

  /// Catalog that is built-in to this package (not downloaded).
  static final builtIn = Catalog(
    units: aggregate.units,
    upgrades: aggregate.upgrades,
  );

  final Map<UnitKey, Unit> _unitsIndexed;

  static Map<UnitKey, Unit> _indexUnits(Iterable<Unit> units) {
    final results = <UnitKey, Unit>{};
    for (final unit in units) {
      results[unit.toKey()] = unit;
    }
    return Map.unmodifiable(results);
  }

  final Map<UpgradeKey, Upgrade> _upgradesIndexed;

  static Map<UpgradeKey, Upgrade> _indexUpgrades(Iterable<Upgrade> upgrades) {
    final results = <UpgradeKey, Upgrade>{};
    for (final upgrade in upgrades) {
      results[upgrade.toKey()] = upgrade;
    }
    return Map.unmodifiable(results);
  }

  Catalog({
    @required Iterable<Unit> units,
    @required Iterable<Upgrade> upgrades,
  })  : _unitsIndexed = _indexUnits(units),
        _upgradesIndexed = _indexUpgrades(upgrades);

  /// Units in the database.
  Iterable<Unit> get units => _unitsIndexed.values;

  /// Upgrades in the database.
  Iterable<Upgrade> get upgrades => _upgradesIndexed.values;

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

  /// Returns the [Unit] for the cooresponding [key].
  Unit lookupUnit(UnitKey key) => _unitsIndexed[key];

  /// Returns the [Upgrade] for the cooresponding [key].
  Upgrade lookupUpgrade(UpgradeKey key) => _upgradesIndexed[key];

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

  /// Returns [Unit]s that can be added to an army of [faction].
  Iterable<Unit> unitsForFaction(Faction faction) {
    return units.where((f) => f.faction == faction);
  }

  /// Returns [Upgrade] that can be added to a [slot].
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
      return u.restrictedToUnit.isEmpty || u.restrictedToUnit.contains(unit);
    });
  }
}
