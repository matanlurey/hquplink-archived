import 'dart:math' as math;

import 'package:built_collection/built_collection.dart';
import 'package:built_value/built_value.dart';
import 'package:hquplink/models.dart';

part 'simulation.g.dart';

abstract class Simulation implements Built<Simulation, SimulationBuilder> {
  factory Simulation() => Simulation._build((b) => b
    ..attack = MapBuilder(const {
      AttackDice.red: 0,
      AttackDice.black: 0,
      AttackDice.white: 0,
    })
    ..defense = DefenseDice.white
    ..hasDefenseSurge = false
    ..cover = 0
    ..dodge = 0
    ..aim = 0);

  factory Simulation._build(void Function(SimulationBuilder) b) = _$Simulation;
  Simulation._();

  /// Amount and type of attack dice.
  BuiltMap<AttackDice, int> get attack;

  /// Type of defense dice.
  DefenseDice get defense;

  /// Whether the defender converts surge icons.
  bool get hasDefenseSurge;

  /// Whether the attacker converts surge icons.
  @nullable
  AttackSurge get attackSurge;

  /// Amount of cover.
  int get cover;

  /// Amount of dodge tokens.
  int get dodge;

  /// Amount of aim tokens.
  int get aim;
}
