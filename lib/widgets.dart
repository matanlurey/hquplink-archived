import 'package:flutter/material.dart';
import 'package:swlegion/swlegion.dart';

export 'src/widgets/dialogs/confirm_dialog.dart';
export 'src/widgets/dialogs/create_army_dialog.dart';
export 'src/widgets/icons/attack_dice_icon.dart';
export 'src/widgets/icons/attack_side_icon.dart';
export 'src/widgets/icons/defense_dice_icon.dart';
export 'src/widgets/icons/defense_side_icon.dart';
export 'src/widgets/icons/faction_icon.dart';
export 'src/widgets/icons/rank_icon.dart';
export 'src/widgets/icons/unit_icon.dart';
export 'src/widgets/icons/upgrade_icon.dart';
export 'src/widgets/misc/dismiss_background.dart';
export 'src/widgets/misc/faction_sliver_header.dart';
export 'src/widgets/misc/max_points_slider.dart';

final _matcher = RegExp(r'[_.\- ]+(\w|$)');

const _darkSideColor = Color(0xFF42556C);
const _lightSideColor = Color(0xFF833C34);
final _neutralColor = Colors.grey.shade300;

/// Returns the [Color] for the provided [faction].
Color factionColor([Faction faction]) {
  switch (faction) {
    case Faction.darkSide:
      return _darkSideColor;
    case Faction.lightSide:
      return _lightSideColor;
    default:
      return _neutralColor;
  }
}

/// Converts a `hyphen-case` [input] string to `'Title Case'`.
String toTitleCase(String input) {
  final result = input.replaceAllMapped(
    _matcher,
    (m) => m.group(0).toUpperCase(),
  );
  return result[0].toUpperCase() + result.substring(1);
}

/// Returns a [keyword] with the value of `'X'` removed if necessary.
///
/// For example, `formatKeyword(Keyword.impactX)` returns `'Impact'`.
String formatKeyword(Keyword keyword) {
  final word = toTitleCase(keyword.name).replaceAll('-', ' ');
  if (word.endsWith(' X')) {
    return '${word.substring(0, word.length - 2)}';
  }
  return word;
}

/// Performs [Iterable.map] including the index of the element mapped over.
Iterable<E> mapIndexed<E, T>(
  Iterable<T> iterable,
  E Function(int, T) fn,
) sync* {
  var i = 0;
  for (final element in iterable) {
    yield fn(i, element);
    i++;
  }
}
