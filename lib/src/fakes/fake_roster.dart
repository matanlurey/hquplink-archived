// ignore_for_file: implementation_imports
import 'package:hquplink/models.dart';

import 'package:swlegion/src/database/units/at_st.dart';
import 'package:swlegion/src/database/units/at_rt.dart';
import 'package:swlegion/src/database/units/leia_organa.dart';
import 'package:swlegion/src/database/units/darth_vader.dart';
import 'package:swlegion/src/database/units/fleet_troopers.dart';
import 'package:swlegion/src/database/units/rebel_commandos_strike_team.dart';
import 'package:swlegion/src/database/units/stormtroopers.dart';
import 'package:swlegion/src/database/upgrades/force/force_push.dart';
import 'package:swlegion/src/database/upgrades/force/force_reflexes.dart';
import 'package:swlegion/src/database/upgrades/force/saber_throw.dart';
import 'package:swlegion/src/database/upgrades/gear/environmental_gear.dart';
import 'package:swlegion/src/database/upgrades/grenades/impact_grenades.dart';
import 'package:swlegion/src/database/upgrades/command/esteemed_leader.dart';
import 'package:swlegion/src/database/upgrades/comms/hq_uplink.dart';
import 'package:swlegion/src/database/upgrades/hardpoint/88_twin_light_blaster_cannon.dart';
import 'package:swlegion/src/database/upgrades/hardpoint/at_rt_laser_cannon.dart';
import 'package:swlegion/src/database/upgrades/hardpoint/at_st_mortar_launcher.dart';
import 'package:swlegion/src/database/upgrades/hardpoint/dw3_concussion_grenade_launcher.dart';
import 'package:swlegion/src/database/upgrades/heavy_weapon/dh_447_sniper.dart';
import 'package:swlegion/src/database/upgrades/heavy_weapon/dlt_19_stormtrooper.dart';
import 'package:swlegion/src/database/upgrades/heavy_weapon/scatter_gun_trooper.dart';
import 'package:swlegion/src/database/upgrades/personnel/fleet_trooper.dart';
import 'package:swlegion/src/database/upgrades/pilot/general_weiss.dart';

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
            ..unit = darthVader.toRef()
            ..upgrades.addAll([
              forcePush.toRef(),
              forceReflexes.toRef(),
              saberThrow.toRef(),
            ])),
          ArmyUnit((b) => b
            ..id = 'local:fake-army:at-st'
            ..unit = atSt.toRef()
            ..upgrades.addAll([
              generalWeiss.toRef(),
              atStMortarLauncher.toRef(),
              $88TwinLightBlasterCannon.toRef(),
              dw3ConcussionGrenadeLauncher.toRef(),
              hqUplink.toRef(),
            ])),
          ArmyUnit((b) => b
            ..id = 'local:fake-army:stormtroopers-1'
            ..unit = stormtroopers.toRef()
            ..upgrades.addAll([
              dlt19Stormtrooper.toRef(),
              impactGrenades.toRef(),
              environmentalGear.toRef(),
            ])),
          ArmyUnit((b) => b
            ..id = 'local:fake-army:stormtroopers-2'
            ..unit = stormtroopers.toRef()
            ..upgrades.addAll([
              dlt19Stormtrooper.toRef(),
              impactGrenades.toRef(),
              environmentalGear.toRef(),
            ])),
          ArmyUnit((b) => b
            ..id = 'local:fake-army:stormtroopers-3'
            ..unit = stormtroopers.toRef()
            ..upgrades.addAll([
              dlt19Stormtrooper.toRef(),
              impactGrenades.toRef(),
              environmentalGear.toRef(),
            ])),
          ArmyUnit((b) => b
            ..id = 'local:fake-army:stormtroopers-4'
            ..unit = stormtroopers.toRef()
            ..upgrades.addAll([
              dlt19Stormtrooper.toRef(),
              impactGrenades.toRef(),
              environmentalGear.toRef(),
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
            ..unit = leiaOrgana.toRef()
            ..upgrades.addAll([
              estmeedLeader.toRef(),
            ])),
          ArmyUnit((b) => b
            ..id = 'local:fake-army:at-rt-1'
            ..unit = atRt.toRef()
            ..upgrades.addAll([
              atRtLaserCannon.toRef(),
              hqUplink.toRef(),
            ])),
          ArmyUnit((b) => b
            ..id = 'local:fake-army:at-rt-2'
            ..unit = atRt.toRef()
            ..upgrades.addAll([
              atRtLaserCannon.toRef(),
              hqUplink.toRef(),
            ])),
          ArmyUnit((b) => b
            ..id = 'local:fake-army:at-rt-3'
            ..unit = atRt.toRef()
            ..upgrades.addAll([
              atRtLaserCannon.toRef(),
              hqUplink.toRef(),
            ])),
          ArmyUnit((b) => b
            ..id = 'local:fake-army:fleets-1'
            ..unit = fleetTroopers.toRef()
            ..upgrades.addAll([
              scatterGunTrooper.toRef(),
              fleetTrooper.toRef(),
              impactGrenades.toRef(),
              environmentalGear.toRef(),
            ])),
          ArmyUnit((b) => b
            ..id = 'local:fake-army:fleets-2'
            ..unit = fleetTroopers.toRef()
            ..upgrades.addAll([
              scatterGunTrooper.toRef(),
              fleetTrooper.toRef(),
              impactGrenades.toRef(),
              environmentalGear.toRef(),
            ])),
          ArmyUnit((b) => b
            ..id = 'local:fake-army:fleets-3'
            ..unit = fleetTroopers.toRef()
            ..upgrades.addAll([
              scatterGunTrooper.toRef(),
              fleetTrooper.toRef(),
              impactGrenades.toRef(),
              environmentalGear.toRef(),
            ])),
          ArmyUnit((b) => b
            ..id = 'local:fake-army:fleets-4'
            ..unit = fleetTroopers.toRef()
            ..upgrades.addAll([
              scatterGunTrooper.toRef(),
              fleetTrooper.toRef(),
              impactGrenades.toRef(),
              environmentalGear.toRef(),
            ])),
          ArmyUnit((b) => b
            ..id = 'local:fake-army:commandos'
            ..unit = rebelCommandosStrikeTeam.toRef()
            ..upgrades.addAll([
              dh447Sniper.toRef(),
              hqUplink.toRef(),
            ])),
        ]))
    ]),
);
