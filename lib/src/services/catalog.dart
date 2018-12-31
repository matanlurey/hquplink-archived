import 'package:hquplink/models.dart';
import 'package:meta/meta.dart';
import 'package:swlegion/database.dart' as aggregate;

import 'unique_ids.dart';

/// Data model for Star Wars: Legion.
///
/// Binds to the model and data from `package:swlegion`, and provides additional
/// functionality for the application such as validation, filtering, and more.
class Catalog extends Holodeck {
  /// Catalog that is built-in to this package (not downloaded).
  static final builtIn = Catalog(
    commands: aggregate.allCommands,
    units: aggregate.allUnits,
    upgrades: aggregate.allUpgrades,
  );

  Catalog({
    @required Iterable<CommandCard> commands,
    @required Iterable<Unit> units,
    @required Iterable<Upgrade> upgrades,
  }) : super(
          commands: commands,
          units: units,
          upgrades: upgrades,
        );

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

  /// Returns the sum of all points in the provided [army].
  int costOfArmy(Army army) {
    return army.units.fold(
      0,
      (p, u) => p + costOfUnit(u.unit, upgrades: u.upgrades),
    );
  }

  /// Returns the sum of all miniatures in the provided [armyUnit].
  int sumMiniatures(ArmyUnit armyUnit) {
    final upgrades = armyUnit.upgrades.map(toUpgrade);
    return upgrades.fold(
      toUnit(armyUnit.unit).miniatures,
      (p, u) => p + (u.addsMiniature ? 1 : 0),
    );
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
}
