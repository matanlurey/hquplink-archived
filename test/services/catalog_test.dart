import 'package:flutter_test/flutter_test.dart';
import 'package:hquplink/models.dart';
import 'package:hquplink/services.dart';
import 'package:swlegion/database.dart';

void main() {
  Catalog catalog;

  setUpAll(() {
    // Set a mock device ID.
    setDeviceId('D1234');
  });

  setUp(() {
    catalog = Catalog.builtIn;
  });

  test('should create a new ArmyBuilder', () {
    final army = catalog.createArmy();
    expect(army.maxPoints, 800);
    expect(army.id, startsWith('local:'));
  });

  test('should create a new ArmyUnitBuilder', () {
    final unit = catalog.createArmyUnit();
    expect(unit.id, startsWith('local:'));
  });

  test('should return the cost of an army', () {
    final army = (catalog.createArmy()
          ..faction = Faction.darkSide
          ..name = 'Test Army'
          ..units.addAll([
            (catalog.createArmyUnit()
                  ..unit = Units.stormtroopers
                  ..upgrades.addAll([
                    Upgrades.dlt19Stormtrooper,
                  ]))
                .build(),
            (catalog.createArmyUnit()
                  ..unit = Units.stormtroopers
                  ..upgrades.addAll([
                    Upgrades.dlt19Stormtrooper,
                  ]))
                .build(),
          ]))
        .build();
    expect(
      catalog.costOfArmy(army),
      (Units.stormtroopers.points + Upgrades.dlt19Stormtrooper.points) * 2,
    );
  });

  test('should return the number of miniatures in a unit', () {
    final unit = (catalog.createArmyUnit()
          ..unit = Units.stormtroopers
          ..upgrades.addAll([
            Upgrades.dlt19Stormtrooper,
            Upgrades.stormtrooper,
          ]))
        .build();
    expect(catalog.sumMiniatures(unit), 6);
  });

  test('should return units that can be added to an army', () {
    // Create a shorter catalog of units.
    catalog = Catalog(
      commands: catalog.commands,
      upgrades: catalog.upgrades,
      units: [
        Units.darthVader,
        Units.stormtroopers,
      ],
    );

    final emptyImperials = (catalog.createArmy()
          ..faction = Faction.darkSide
          ..name = 'Test Army')
        .build();

    expect(
      catalog.unitsForArmy(emptyImperials),
      [
        Units.darthVader,
        Units.stormtroopers,
      ],
      reason: 'Army is empty and can include any Imperial unit',
    );

    final smallImperials = emptyImperials.rebuild((b) {
      b.units.addAll([
        (catalog.createArmyUnit()..unit = Units.darthVader).build(),
        (catalog.createArmyUnit()..unit = Units.stormtroopers).build(),
      ]);
    });

    expect(
      catalog.unitsForArmy(smallImperials),
      containsAll(<Unit>[
        Units.stormtroopers,
      ]),
      reason: 'Darth Vader is unique and is already included',
    );

    final emptyRebels = emptyImperials.rebuild(
      (b) => b.faction = Faction.lightSide,
    );

    expect(
      catalog.unitsForArmy(emptyRebels),
      isEmpty,
      reason: 'Catalog has no Rebel units',
    );
  });
}
