import 'package:meta/meta.dart';
import 'package:swlegion/database.dart' as aggregate;
import 'package:swlegion/swlegion.dart';

import 'unique_ids.dart';

class Catalog {
  /// Catalog that is built-in to this package (not downloaded).
  static final builtIn = Catalog(
    units: aggregate.units,
    upgrades: aggregate.upgrades,
  );

  /// Units in the database.
  final List<Unit> units;

  /// Upgrades in the database.
  final List<Upgrade> upgrades;

  Catalog({
    @required Iterable<Unit> units,
    @required Iterable<Upgrade> upgrades,
  })  : units = List.unmodifiable(units),
        upgrades = List.unmodifiable(upgrades);

  /// Creates a new empty [ArmyBuilder] with [ArmyBuilder.id] preset.
  ArmyBuilder createArmy() => ArmyBuilder()
    ..maxPoints = 800
    ..id = generateLocalId();

  /// Creates a new empty [ArmyUnitBuilder] with [ArmyUnitBuilder.id] preset.
  ArmyUnitBuilder createArmyUnit() => ArmyUnitBuilder()..id = generateLocalId();
}
