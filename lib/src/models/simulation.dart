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
      ..aim = 0
      ..pierce = 0
      ..impact = 0
      ..armor = false);
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

  /// Pierce in the dice pool.
  int get pierce;

  /// Impact in the dice pool.
  int get impact;

  /// Whether armor is in the defense.
  bool get armor;

  /// Computes and returns the expected wounds.
  double expectedWounds() {
    // Possible attacks, without surge.
    final attackFrames = _possibleAttacks(_attackPool()).map((pool) {
      return _RawAttackFrame(attackPool: pool);
    });

    // Possible attacks, with surge applied.
    final convertedFrames = attackFrames.map((a) => a.convert(attackSurge));

    // Total expected wounds.
    return convertedFrames.fold<double>(
          0,
          (e, f) {
            return e +
                f.expectedWounds(
                  dice: defense,
                  hasDefenseSurge: hasDefenseSurge,
                  cover: cover,
                  pierce: pierce,
                  impact: impact,
                  armor: armor,
                );
          },
        ) /
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
  double expectedWounds({
    @required DefenseDice dice,
    @required bool hasDefenseSurge,
    @required int cover,
    @required int pierce,
    @required int impact,
    @required bool armor,
  }) {
    // Hits with cover.
    var totalHits = math.max(this.totalHits - cover, 0);
    var totalCrits = this.totalCrits;

    // Apply armor and impact.
    if (armor) {
      while (totalHits > 0 && impact > 0) {
        impact--;
        totalHits--;
        totalCrits++;
      }
      totalHits = 0;
    }

    // Determine total amount of defense wounds and possible wounds.l
    final possibleWounds = totalHits + totalCrits;

    // No point in rolling defensive dice if we aren't going to hit anyway.
    if (possibleWounds <= 0) {
      return 0;
    }

    // Determine chances of blocking every possible wound.
    final blockSides = dice.sides
        .where((s) =>
            s == DefenseDiceSide.block ||
            hasDefenseSurge && s == DefenseDiceSide.surge)
        .length;
    final blockChance = blockSides / dice.sides.length;

    // Determine "expected" blocks, applying pierce.
    final expectedBlocks = () {
      var result = 0.0;
      for (var i = 0; i < possibleWounds; i++) {
        // Apply pierce.
        if (pierce > 0) {
          pierce--;
          continue;
        }

        // Add expected block chance.
        result += blockChance;
      }
      return result;
    }();

    return possibleWounds - expectedBlocks;
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
