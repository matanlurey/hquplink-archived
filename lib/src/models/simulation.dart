import 'dart:math' as math;

import 'package:built_collection/built_collection.dart';
import 'package:built_value/built_value.dart';
import 'package:hquplink/models.dart';
import 'package:meta/meta.dart';

part 'simulation.g.dart';

abstract class Simulation implements Built<Simulation, SimulationBuilder> {
  factory Simulation([void Function(SimulationBuilder) builder]) {
    final intermediate = Simulation._build((b) => b
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
    if (builder != null) {
      return intermediate.rebuild(builder);
    }
    return intermediate;
  }

  factory Simulation._build(void Function(SimulationBuilder) b) = _$Simulation;
  Simulation._();

  /// Amount and type of attack dice.
  BuiltMap<AttackDice, int> get attack;

  /// Returns the [attack] as a pool of dice.
  List<AttackDice> _attackPool() {
    return attack.entries.fold<List<AttackDice>>([], (r, e) {
      for (var i = 0; i < e.value; i++) {
        r.add(e.key);
      }
      return r;
    });
  }

  /// Context for this simulation, if any.
  @nullable
  String get context;

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

  /// Computes and returns the expected wounds.
  double expectedWounds() {
    // Possible attacks, without surge.
    final attackFrames = _possibleAttacks(_attackPool()).map((pool) {
      return _RawAttackFrame(attackPool: pool);
    });

    // Possible attacks, with surge applied.
    final convertedFrames = attackFrames.map((a) => a.convert(attackSurge));

    // Total expected wounds.
    return convertedFrames.fold<double>(0, (e, f) {
          return e + f.expectedWounds(defense, hasDefenseSurge);
        }) /
        attackFrames.length;
  }
}

/// Represents a possible frame, with an [attackPool].
class _RawAttackFrame {
  final List<AttackDiceSide> attackPool;

  const _RawAttackFrame({
    @required this.attackPool,
  });

  _ConvertedAttackFrame convert(AttackSurge surge) {
    var totalHits = 0;
    var totalCrits = 0;
    var totalMisses = 0;
    for (var side in attackPool) {
      if (side == AttackDiceSide.surge) {
        switch (surge) {
          case AttackSurge.hit:
            side = AttackDiceSide.hit;
            break;
          case AttackSurge.critical:
            side = AttackDiceSide.criticalHit;
            break;
          default:
            side = AttackDiceSide.blank;
            break;
        }
      }
      switch (side) {
        case AttackDiceSide.hit:
          totalHits++;
          break;
        case AttackDiceSide.criticalHit:
          totalCrits++;
          break;
        default:
          totalMisses++;
          break;
      }
    }
    return _ConvertedAttackFrame(
      totalHits: totalHits,
      totalCrits: totalCrits,
      totalMisses: totalMisses,
    );
  }
}

/// Represenst a possible frame with [AttackSurge] applied.
class _ConvertedAttackFrame {
  final int totalHits;
  final int totalCrits;
  final int totalMisses;

  const _ConvertedAttackFrame({
    @required this.totalHits,
    @required this.totalCrits,
    @required this.totalMisses,
  });

  // ignore: avoid_positional_boolean_parameters
  double expectedWounds(DefenseDice dice, bool hasDefenseSurge) {
    final totalDice = totalHits + totalCrits;
    if (totalDice == 0) {
      return 0;
    }
    final blockSides = dice.sides
        .where((s) =>
            s == DefenseDiceSide.block ||
            hasDefenseSurge && s == DefenseDiceSide.surge)
        .length;
    final blockChance = blockSides / dice.sides.length;
    return totalDice * (1 - blockChance);
  }
}

/// Returns all possible results given a [pool] of attack dice.
List<List<AttackDiceSide>> _possibleAttacks(List<AttackDice> pool) {
  final total = math.pow(8, pool.length).toInt();
  final slots = new List<List<AttackDiceSide>>.generate(total, (_) => []);
  return pool.fold(slots, (results, dice) {
    for (var i = 0; i < results.length; i++) {
      final side = i % dice.sides.length;
      results[i].add(dice.sides[side]);
    }
    return results;
  });
}
