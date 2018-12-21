import 'package:built_collection/built_collection.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';
import 'package:meta/meta.dart';
import 'package:swlegion/swlegion.dart';

part 'roster.g.dart';

/// Represents a collection of [Army] lists, usually for a device or user.
@Immutable()
abstract class Roster implements Built<Roster, RosterBuilder> {
  static Serializer<Roster> get serializer => _$rosterSerializer;

  factory Roster(void Function(RosterBuilder) build) = _$Roster;
  Roster._();

  /// Army lists.
  BuiltList<Army> get armies;
}
