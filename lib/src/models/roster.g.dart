// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'roster.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

Serializer<Roster> _$rosterSerializer = new _$RosterSerializer();

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

// ignore_for_file: always_put_control_body_on_new_line,annotate_overrides,avoid_annotating_with_dynamic,avoid_as,avoid_catches_without_on_clauses,avoid_returning_this,lines_longer_than_80_chars,omit_local_variable_types,prefer_expression_function_bodies,sort_constructors_first,test_types_in_equals,unnecessary_const,unnecessary_new
