// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'roster.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

Serializer<Roster> _$rosterSerializer = new _$RosterSerializer();
Serializer<Army> _$armySerializer = new _$ArmySerializer();
Serializer<ArmyUnit> _$armyUnitSerializer = new _$ArmyUnitSerializer();

class _$RosterSerializer implements StructuredSerializer<Roster> {
  @override
  final Iterable<Type> types = const [Roster, _$Roster];
  @override
  final String wireName = 'Roster';

  @override
  Iterable serialize(Serializers serializers, Roster object,
      {FullType specifiedType = FullType.unspecified}) {
    final result = <Object>[
      'armies',
      serializers.serialize(object.armies,
          specifiedType:
              const FullType(BuiltList, const [const FullType(Army)])),
    ];

    return result;
  }

  @override
  Roster deserialize(Serializers serializers, Iterable serialized,
      {FullType specifiedType = FullType.unspecified}) {
    final result = new RosterBuilder();

    final iterator = serialized.iterator;
    while (iterator.moveNext()) {
      final key = iterator.current as String;
      iterator.moveNext();
      final dynamic value = iterator.current;
      switch (key) {
        case 'armies':
          result.armies.replace(serializers.deserialize(value,
                  specifiedType:
                      const FullType(BuiltList, const [const FullType(Army)]))
              as BuiltList);
          break;
      }
    }

    return result.build();
  }
}

class _$ArmySerializer implements StructuredSerializer<Army> {
  @override
  final Iterable<Type> types = const [Army, _$Army];
  @override
  final String wireName = 'Army';

  @override
  Iterable serialize(Serializers serializers, Army object,
      {FullType specifiedType = FullType.unspecified}) {
    final result = <Object>[
      'id',
      serializers.serialize(object.id, specifiedType: const FullType(String)),
      'faction',
      serializers.serialize(object.faction,
          specifiedType: const FullType(Faction)),
      'maxPoints',
      serializers.serialize(object.maxPoints,
          specifiedType: const FullType(int)),
      'name',
      serializers.serialize(object.name, specifiedType: const FullType(String)),
      'units',
      serializers.serialize(object.units,
          specifiedType:
              const FullType(BuiltList, const [const FullType(ArmyUnit)])),
      'commands',
      serializers.serialize(object.commands,
          specifiedType: const FullType(BuiltSet, const [
            const FullType(Reference, const [const FullType(CommandCard)])
          ])),
    ];

    return result;
  }

  @override
  Army deserialize(Serializers serializers, Iterable serialized,
      {FullType specifiedType = FullType.unspecified}) {
    final result = new ArmyBuilder();

    final iterator = serialized.iterator;
    while (iterator.moveNext()) {
      final key = iterator.current as String;
      iterator.moveNext();
      final dynamic value = iterator.current;
      switch (key) {
        case 'id':
          result.id = serializers.deserialize(value,
              specifiedType: const FullType(String)) as String;
          break;
        case 'faction':
          result.faction = serializers.deserialize(value,
              specifiedType: const FullType(Faction)) as Faction;
          break;
        case 'maxPoints':
          result.maxPoints = serializers.deserialize(value,
              specifiedType: const FullType(int)) as int;
          break;
        case 'name':
          result.name = serializers.deserialize(value,
              specifiedType: const FullType(String)) as String;
          break;
        case 'units':
          result.units.replace(serializers.deserialize(value,
              specifiedType: const FullType(
                  BuiltList, const [const FullType(ArmyUnit)])) as BuiltList);
          break;
        case 'commands':
          result.commands.replace(serializers.deserialize(value,
              specifiedType: const FullType(BuiltSet, const [
                const FullType(Reference, const [const FullType(CommandCard)])
              ])) as BuiltSet);
          break;
      }
    }

    return result.build();
  }
}

class _$ArmyUnitSerializer implements StructuredSerializer<ArmyUnit> {
  @override
  final Iterable<Type> types = const [ArmyUnit, _$ArmyUnit];
  @override
  final String wireName = 'ArmyUnit';

  @override
  Iterable serialize(Serializers serializers, ArmyUnit object,
      {FullType specifiedType = FullType.unspecified}) {
    final result = <Object>[
      'id',
      serializers.serialize(object.id, specifiedType: const FullType(String)),
      'unit',
      serializers.serialize(object.unit,
          specifiedType:
              const FullType(Reference, const [const FullType(Unit)])),
      'upgrades',
      serializers.serialize(object.upgrades,
          specifiedType: const FullType(BuiltSet, const [
            const FullType(Reference, const [const FullType(Upgrade)])
          ])),
    ];

    return result;
  }

  @override
  ArmyUnit deserialize(Serializers serializers, Iterable serialized,
      {FullType specifiedType = FullType.unspecified}) {
    final result = new ArmyUnitBuilder();

    final iterator = serialized.iterator;
    while (iterator.moveNext()) {
      final key = iterator.current as String;
      iterator.moveNext();
      final dynamic value = iterator.current;
      switch (key) {
        case 'id':
          result.id = serializers.deserialize(value,
              specifiedType: const FullType(String)) as String;
          break;
        case 'unit':
          result.unit = serializers.deserialize(value,
                  specifiedType:
                      const FullType(Reference, const [const FullType(Unit)]))
              as Reference<Unit>;
          break;
        case 'upgrades':
          result.upgrades.replace(serializers.deserialize(value,
              specifiedType: const FullType(BuiltSet, const [
                const FullType(Reference, const [const FullType(Upgrade)])
              ])) as BuiltSet);
          break;
      }
    }

    return result.build();
  }
}

class _$Roster extends Roster {
  @override
  final BuiltList<Army> armies;

  factory _$Roster([void updates(RosterBuilder b)]) =>
      (new RosterBuilder()..update(updates)).build();

  _$Roster._({this.armies}) : super._() {
    if (armies == null) {
      throw new BuiltValueNullFieldError('Roster', 'armies');
    }
  }

  @override
  Roster rebuild(void updates(RosterBuilder b)) =>
      (toBuilder()..update(updates)).build();

  @override
  RosterBuilder toBuilder() => new RosterBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is Roster && armies == other.armies;
  }

  @override
  int get hashCode {
    return $jf($jc(0, armies.hashCode));
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper('Roster')..add('armies', armies))
        .toString();
  }
}

class RosterBuilder implements Builder<Roster, RosterBuilder> {
  _$Roster _$v;

  ListBuilder<Army> _armies;
  ListBuilder<Army> get armies => _$this._armies ??= new ListBuilder<Army>();
  set armies(ListBuilder<Army> armies) => _$this._armies = armies;

  RosterBuilder();

  RosterBuilder get _$this {
    if (_$v != null) {
      _armies = _$v.armies?.toBuilder();
      _$v = null;
    }
    return this;
  }

  @override
  void replace(Roster other) {
    if (other == null) {
      throw new ArgumentError.notNull('other');
    }
    _$v = other as _$Roster;
  }

  @override
  void update(void updates(RosterBuilder b)) {
    if (updates != null) updates(this);
  }

  @override
  _$Roster build() {
    _$Roster _$result;
    try {
      _$result = _$v ?? new _$Roster._(armies: armies.build());
    } catch (_) {
      String _$failedField;
      try {
        _$failedField = 'armies';
        armies.build();
      } catch (e) {
        throw new BuiltValueNestedFieldError(
            'Roster', _$failedField, e.toString());
      }
      rethrow;
    }
    replace(_$result);
    return _$result;
  }
}

class _$Army extends Army {
  @override
  final String id;
  @override
  final Faction faction;
  @override
  final int maxPoints;
  @override
  final String name;
  @override
  final BuiltList<ArmyUnit> units;
  @override
  final BuiltSet<Reference<CommandCard>> commands;

  factory _$Army([void updates(ArmyBuilder b)]) =>
      (new ArmyBuilder()..update(updates)).build();

  _$Army._(
      {this.id,
      this.faction,
      this.maxPoints,
      this.name,
      this.units,
      this.commands})
      : super._() {
    if (id == null) {
      throw new BuiltValueNullFieldError('Army', 'id');
    }
    if (faction == null) {
      throw new BuiltValueNullFieldError('Army', 'faction');
    }
    if (maxPoints == null) {
      throw new BuiltValueNullFieldError('Army', 'maxPoints');
    }
    if (name == null) {
      throw new BuiltValueNullFieldError('Army', 'name');
    }
    if (units == null) {
      throw new BuiltValueNullFieldError('Army', 'units');
    }
    if (commands == null) {
      throw new BuiltValueNullFieldError('Army', 'commands');
    }
  }

  @override
  Army rebuild(void updates(ArmyBuilder b)) =>
      (toBuilder()..update(updates)).build();

  @override
  ArmyBuilder toBuilder() => new ArmyBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is Army &&
        id == other.id &&
        faction == other.faction &&
        maxPoints == other.maxPoints &&
        name == other.name &&
        units == other.units &&
        commands == other.commands;
  }

  @override
  int get hashCode {
    return $jf($jc(
        $jc(
            $jc(
                $jc($jc($jc(0, id.hashCode), faction.hashCode),
                    maxPoints.hashCode),
                name.hashCode),
            units.hashCode),
        commands.hashCode));
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper('Army')
          ..add('id', id)
          ..add('faction', faction)
          ..add('maxPoints', maxPoints)
          ..add('name', name)
          ..add('units', units)
          ..add('commands', commands))
        .toString();
  }
}

class ArmyBuilder implements Builder<Army, ArmyBuilder> {
  _$Army _$v;

  String _id;
  String get id => _$this._id;
  set id(String id) => _$this._id = id;

  Faction _faction;
  Faction get faction => _$this._faction;
  set faction(Faction faction) => _$this._faction = faction;

  int _maxPoints;
  int get maxPoints => _$this._maxPoints;
  set maxPoints(int maxPoints) => _$this._maxPoints = maxPoints;

  String _name;
  String get name => _$this._name;
  set name(String name) => _$this._name = name;

  ListBuilder<ArmyUnit> _units;
  ListBuilder<ArmyUnit> get units =>
      _$this._units ??= new ListBuilder<ArmyUnit>();
  set units(ListBuilder<ArmyUnit> units) => _$this._units = units;

  SetBuilder<Reference<CommandCard>> _commands;
  SetBuilder<Reference<CommandCard>> get commands =>
      _$this._commands ??= new SetBuilder<Reference<CommandCard>>();
  set commands(SetBuilder<Reference<CommandCard>> commands) =>
      _$this._commands = commands;

  ArmyBuilder();

  ArmyBuilder get _$this {
    if (_$v != null) {
      _id = _$v.id;
      _faction = _$v.faction;
      _maxPoints = _$v.maxPoints;
      _name = _$v.name;
      _units = _$v.units?.toBuilder();
      _commands = _$v.commands?.toBuilder();
      _$v = null;
    }
    return this;
  }

  @override
  void replace(Army other) {
    if (other == null) {
      throw new ArgumentError.notNull('other');
    }
    _$v = other as _$Army;
  }

  @override
  void update(void updates(ArmyBuilder b)) {
    if (updates != null) updates(this);
  }

  @override
  _$Army build() {
    _$Army _$result;
    try {
      _$result = _$v ??
          new _$Army._(
              id: id,
              faction: faction,
              maxPoints: maxPoints,
              name: name,
              units: units.build(),
              commands: commands.build());
    } catch (_) {
      String _$failedField;
      try {
        _$failedField = 'units';
        units.build();
        _$failedField = 'commands';
        commands.build();
      } catch (e) {
        throw new BuiltValueNestedFieldError(
            'Army', _$failedField, e.toString());
      }
      rethrow;
    }
    replace(_$result);
    return _$result;
  }
}

class _$ArmyUnit extends ArmyUnit {
  @override
  final String id;
  @override
  final Reference<Unit> unit;
  @override
  final BuiltSet<Reference<Upgrade>> upgrades;

  factory _$ArmyUnit([void updates(ArmyUnitBuilder b)]) =>
      (new ArmyUnitBuilder()..update(updates)).build();

  _$ArmyUnit._({this.id, this.unit, this.upgrades}) : super._() {
    if (id == null) {
      throw new BuiltValueNullFieldError('ArmyUnit', 'id');
    }
    if (unit == null) {
      throw new BuiltValueNullFieldError('ArmyUnit', 'unit');
    }
    if (upgrades == null) {
      throw new BuiltValueNullFieldError('ArmyUnit', 'upgrades');
    }
  }

  @override
  ArmyUnit rebuild(void updates(ArmyUnitBuilder b)) =>
      (toBuilder()..update(updates)).build();

  @override
  ArmyUnitBuilder toBuilder() => new ArmyUnitBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is ArmyUnit &&
        id == other.id &&
        unit == other.unit &&
        upgrades == other.upgrades;
  }

  @override
  int get hashCode {
    return $jf($jc($jc($jc(0, id.hashCode), unit.hashCode), upgrades.hashCode));
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper('ArmyUnit')
          ..add('id', id)
          ..add('unit', unit)
          ..add('upgrades', upgrades))
        .toString();
  }
}

class ArmyUnitBuilder implements Builder<ArmyUnit, ArmyUnitBuilder> {
  _$ArmyUnit _$v;

  String _id;
  String get id => _$this._id;
  set id(String id) => _$this._id = id;

  Reference<Unit> _unit;
  Reference<Unit> get unit => _$this._unit;
  set unit(Reference<Unit> unit) => _$this._unit = unit;

  SetBuilder<Reference<Upgrade>> _upgrades;
  SetBuilder<Reference<Upgrade>> get upgrades =>
      _$this._upgrades ??= new SetBuilder<Reference<Upgrade>>();
  set upgrades(SetBuilder<Reference<Upgrade>> upgrades) =>
      _$this._upgrades = upgrades;

  ArmyUnitBuilder();

  ArmyUnitBuilder get _$this {
    if (_$v != null) {
      _id = _$v.id;
      _unit = _$v.unit;
      _upgrades = _$v.upgrades?.toBuilder();
      _$v = null;
    }
    return this;
  }

  @override
  void replace(ArmyUnit other) {
    if (other == null) {
      throw new ArgumentError.notNull('other');
    }
    _$v = other as _$ArmyUnit;
  }

  @override
  void update(void updates(ArmyUnitBuilder b)) {
    if (updates != null) updates(this);
  }

  @override
  _$ArmyUnit build() {
    _$ArmyUnit _$result;
    try {
      _$result = _$v ??
          new _$ArmyUnit._(id: id, unit: unit, upgrades: upgrades.build());
    } catch (_) {
      String _$failedField;
      try {
        _$failedField = 'upgrades';
        upgrades.build();
      } catch (e) {
        throw new BuiltValueNestedFieldError(
            'ArmyUnit', _$failedField, e.toString());
      }
      rethrow;
    }
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: always_put_control_body_on_new_line,annotate_overrides,avoid_annotating_with_dynamic,avoid_as,avoid_catches_without_on_clauses,avoid_returning_this,lines_longer_than_80_chars,omit_local_variable_types,prefer_expression_function_bodies,sort_constructors_first,test_types_in_equals,unnecessary_const,unnecessary_new
