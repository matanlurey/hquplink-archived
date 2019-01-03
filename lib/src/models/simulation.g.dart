// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'simulation.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$Simulation extends Simulation {
  @override
  final BuiltMap<AttackDice, int> attack;
  @override
  final String context;
  @override
  final DefenseDice defense;
  @override
  final bool hasDefenseSurge;
  @override
  final AttackSurge attackSurge;
  @override
  final int cover;
  @override
  final int dodge;
  @override
  final int aim;

  factory _$Simulation([void updates(SimulationBuilder b)]) =>
      (new SimulationBuilder()..update(updates)).build();

  _$Simulation._(
      {this.attack,
      this.context,
      this.defense,
      this.hasDefenseSurge,
      this.attackSurge,
      this.cover,
      this.dodge,
      this.aim})
      : super._() {
    if (attack == null) {
      throw new BuiltValueNullFieldError('Simulation', 'attack');
    }
    if (defense == null) {
      throw new BuiltValueNullFieldError('Simulation', 'defense');
    }
    if (hasDefenseSurge == null) {
      throw new BuiltValueNullFieldError('Simulation', 'hasDefenseSurge');
    }
    if (cover == null) {
      throw new BuiltValueNullFieldError('Simulation', 'cover');
    }
    if (dodge == null) {
      throw new BuiltValueNullFieldError('Simulation', 'dodge');
    }
    if (aim == null) {
      throw new BuiltValueNullFieldError('Simulation', 'aim');
    }
  }

  @override
  Simulation rebuild(void updates(SimulationBuilder b)) =>
      (toBuilder()..update(updates)).build();

  @override
  SimulationBuilder toBuilder() => new SimulationBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is Simulation &&
        attack == other.attack &&
        context == other.context &&
        defense == other.defense &&
        hasDefenseSurge == other.hasDefenseSurge &&
        attackSurge == other.attackSurge &&
        cover == other.cover &&
        dodge == other.dodge &&
        aim == other.aim;
  }

  @override
  int get hashCode {
    return $jf($jc(
        $jc(
            $jc(
                $jc(
                    $jc(
                        $jc($jc($jc(0, attack.hashCode), context.hashCode),
                            defense.hashCode),
                        hasDefenseSurge.hashCode),
                    attackSurge.hashCode),
                cover.hashCode),
            dodge.hashCode),
        aim.hashCode));
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper('Simulation')
          ..add('attack', attack)
          ..add('context', context)
          ..add('defense', defense)
          ..add('hasDefenseSurge', hasDefenseSurge)
          ..add('attackSurge', attackSurge)
          ..add('cover', cover)
          ..add('dodge', dodge)
          ..add('aim', aim))
        .toString();
  }
}

class SimulationBuilder implements Builder<Simulation, SimulationBuilder> {
  _$Simulation _$v;

  MapBuilder<AttackDice, int> _attack;
  MapBuilder<AttackDice, int> get attack =>
      _$this._attack ??= new MapBuilder<AttackDice, int>();
  set attack(MapBuilder<AttackDice, int> attack) => _$this._attack = attack;

  String _context;
  String get context => _$this._context;
  set context(String context) => _$this._context = context;

  DefenseDice _defense;
  DefenseDice get defense => _$this._defense;
  set defense(DefenseDice defense) => _$this._defense = defense;

  bool _hasDefenseSurge;
  bool get hasDefenseSurge => _$this._hasDefenseSurge;
  set hasDefenseSurge(bool hasDefenseSurge) =>
      _$this._hasDefenseSurge = hasDefenseSurge;

  AttackSurge _attackSurge;
  AttackSurge get attackSurge => _$this._attackSurge;
  set attackSurge(AttackSurge attackSurge) => _$this._attackSurge = attackSurge;

  int _cover;
  int get cover => _$this._cover;
  set cover(int cover) => _$this._cover = cover;

  int _dodge;
  int get dodge => _$this._dodge;
  set dodge(int dodge) => _$this._dodge = dodge;

  int _aim;
  int get aim => _$this._aim;
  set aim(int aim) => _$this._aim = aim;

  SimulationBuilder();

  SimulationBuilder get _$this {
    if (_$v != null) {
      _attack = _$v.attack?.toBuilder();
      _context = _$v.context;
      _defense = _$v.defense;
      _hasDefenseSurge = _$v.hasDefenseSurge;
      _attackSurge = _$v.attackSurge;
      _cover = _$v.cover;
      _dodge = _$v.dodge;
      _aim = _$v.aim;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(Simulation other) {
    if (other == null) {
      throw new ArgumentError.notNull('other');
    }
    _$v = other as _$Simulation;
  }

  @override
  void update(void updates(SimulationBuilder b)) {
    if (updates != null) updates(this);
  }

  @override
  _$Simulation build() {
    _$Simulation _$result;
    try {
      _$result = _$v ??
          new _$Simulation._(
              attack: attack.build(),
              context: context,
              defense: defense,
              hasDefenseSurge: hasDefenseSurge,
              attackSurge: attackSurge,
              cover: cover,
              dodge: dodge,
              aim: aim);
    } catch (_) {
      String _$failedField;
      try {
        _$failedField = 'attack';
        attack.build();
      } catch (e) {
        throw new BuiltValueNestedFieldError(
            'Simulation', _$failedField, e.toString());
      }
      rethrow;
    }
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: always_put_control_body_on_new_line,annotate_overrides,avoid_annotating_with_dynamic,avoid_as,avoid_catches_without_on_clauses,avoid_returning_this,lines_longer_than_80_chars,omit_local_variable_types,prefer_expression_function_bodies,sort_constructors_first,test_types_in_equals,unnecessary_const,unnecessary_new
