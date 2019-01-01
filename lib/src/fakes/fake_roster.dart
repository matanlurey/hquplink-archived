// ignore_for_file: implementation_imports
import 'package:hquplink/models.dart';
import 'package:swlegion/database.dart';

final fakeRoster = Roster(
  (b) => b
    ..armies.addAll([
      Army((b) => b
        ..faction = Faction.darkSide
        ..id = 'local:fake-army-1'
        ..maxPoints = 800
        ..name = '501st Legion'
        ..units.addAll([
          ArmyUnit((b) => b
            ..id = 'local:fake-army:darth-vader'
            ..unit = Units.darthVader
            ..upgrades.addAll([
              Upgrades.forcePush,
              Upgrades.forceReflexes,
              Upgrades.saberThrow,
            ])),
          ArmyUnit((b) => b
            ..id = 'local:fake-army:at-st'
            ..unit = Units.atSt
            ..upgrades.addAll([
              Upgrades.generalWeiss,
              Upgrades.atStMortarLauncher,
              Upgrades.$88TwinLightBlasterCannon,
              Upgrades.dw3ConcussionGrenadeLauncher,
              Upgrades.hqUplink,
            ])),
          ArmyUnit((b) => b
            ..id = 'local:fake-army:stormtroopers-1'
            ..unit = Units.stormtroopers
            ..upgrades.addAll([
              Upgrades.dlt19Stormtrooper,
              Upgrades.impactGrenades,
              Upgrades.environmentalGear,
            ])),
          ArmyUnit((b) => b
            ..id = 'local:fake-army:stormtroopers-2'
            ..unit = Units.stormtroopers
            ..upgrades.addAll([
              Upgrades.dlt19Stormtrooper,
              Upgrades.impactGrenades,
              Upgrades.environmentalGear,
            ])),
          ArmyUnit((b) => b
            ..id = 'local:fake-army:stormtroopers-3'
            ..unit = Units.stormtroopers
            ..upgrades.addAll([
              Upgrades.dlt19Stormtrooper,
              Upgrades.impactGrenades,
              Upgrades.environmentalGear,
            ])),
          ArmyUnit((b) => b
            ..id = 'local:fake-army:stormtroopers-4'
            ..unit = Units.stormtroopers
            ..upgrades.addAll([
              Upgrades.dlt19Stormtrooper,
              Upgrades.impactGrenades,
              Upgrades.environmentalGear,
            ])),
        ])),
      Army((b) => b
        ..faction = Faction.lightSide
        ..id = 'local:fake-army-2'
        ..maxPoints = 800
        ..name = 'Tantive IV Security'
        ..units.addAll([
          ArmyUnit((b) => b
            ..id = 'local:fake-army:leia-organa'
            ..unit = Units.leiaOrgana
            ..upgrades.addAll([
              Upgrades.estmeedLeader,
            ])),
          ArmyUnit((b) => b
            ..id = 'local:fake-army:at-rt-1'
            ..unit = Units.atRt
            ..upgrades.addAll([
              Upgrades.atRtLaserCannon,
              Upgrades.hqUplink,
            ])),
          ArmyUnit((b) => b
            ..id = 'local:fake-army:at-rt-2'
            ..unit = Units.atRt
            ..upgrades.addAll([
              Upgrades.atRtLaserCannon,
              Upgrades.hqUplink,
            ])),
          ArmyUnit((b) => b
            ..id = 'local:fake-army:at-rt-3'
            ..unit = Units.atRt
            ..upgrades.addAll([
              Upgrades.atRtLaserCannon,
              Upgrades.hqUplink,
            ])),
          ArmyUnit((b) => b
            ..id = 'local:fake-army:fleets-1'
            ..unit = Units.fleetTroopers
            ..upgrades.addAll([
              Upgrades.scatterGunTrooper,
              Upgrades.fleetTrooper,
              Upgrades.impactGrenades,
              Upgrades.environmentalGear,
            ])),
          ArmyUnit((b) => b
            ..id = 'local:fake-army:fleets-2'
            ..unit = Units.fleetTroopers
            ..upgrades.addAll([
              Upgrades.scatterGunTrooper,
              Upgrades.fleetTrooper,
              Upgrades.impactGrenades,
              Upgrades.environmentalGear,
            ])),
          ArmyUnit((b) => b
            ..id = 'local:fake-army:fleets-3'
            ..unit = Units.fleetTroopers
            ..upgrades.addAll([
              Upgrades.scatterGunTrooper,
              Upgrades.fleetTrooper,
              Upgrades.impactGrenades,
              Upgrades.environmentalGear,
            ])),
          ArmyUnit((b) => b
            ..id = 'local:fake-army:fleets-4'
            ..unit = Units.fleetTroopers
            ..upgrades.addAll([
              Upgrades.scatterGunTrooper,
              Upgrades.fleetTrooper,
              Upgrades.impactGrenades,
              Upgrades.environmentalGear,
            ])),
          ArmyUnit((b) => b
            ..id = 'local:fake-army:commandos'
            ..unit = Units.rebelCommandosStrikeTeam
            ..upgrades.addAll([
              Upgrades.dh447Sniper,
              Upgrades.hqUplink,
            ])),
        ]))
    ]),
);
