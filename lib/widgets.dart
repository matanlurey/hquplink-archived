import 'package:swlegion/swlegion.dart';

export 'src/widgets/dialogs/add_army_dialog.dart';
export 'src/widgets/dialogs/confirm_dialog.dart';
export 'src/widgets/icons/attack_dice_icon.dart';
export 'src/widgets/icons/defense_dice_icon.dart';
export 'src/widgets/icons/faction_icon.dart';
export 'src/widgets/icons/rank_icon.dart';
export 'src/widgets/icons/unit_icon.dart';
export 'src/widgets/icons/upgrade_icon.dart';
export 'src/widgets/misc/max_points_slider.dart';
export 'src/widgets/tiles/preview_army_tile.dart';

bool _isCapitalized(int character) => character >= 65 && character < 97;

/// Converts a [camelCased] string to `'Title Case'`.
String toTitleCase(String camelCased) {
  final buffer = StringBuffer();
  for (var i = 0; i < camelCased.length; i++) {
    final character = camelCased.codeUnitAt(i);
    if (_isCapitalized(character)) {
      buffer..write(' ')..write(String.fromCharCode(character));
    } else {
      var letter = String.fromCharCode(character);
      if (i == 0) {
        letter = letter.toUpperCase();
      }
      buffer.write(letter);
    }
  }
  return buffer.toString();
}

/// Returns a [keyword] with the value of `'X'` removed if necessary.
///
/// For example, `formatKeyword(Keyword.impactX)` returns `'Impact'`.
String formatKeyword(Keyword keyword) {
  final word = toTitleCase(keyword.name);
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
