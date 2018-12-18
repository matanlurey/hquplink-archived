import 'package:swlegion/swlegion.dart';

bool _isCapitalized(int character) => character >= 65 && character < 97;

String camelToTitleCase(String camelCased) {
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

String abbreviate(String hasUppercaseChars, {int max = 2}) {
  final buffer = StringBuffer();
  for (var i = 0; i < hasUppercaseChars.length; i++) {
    final character = hasUppercaseChars.codeUnitAt(i);
    if (_isCapitalized(character)) {
      buffer.writeCharCode(character);
    }
  }
  final result = buffer.toString();
  return result.length > max ? result.substring(result.length - max) : result;
}

/// Returns a [keyword] with the value of `'X'` replaced if necessary.
///
/// For example, `mapKeyword(Keyword.impactX, '5')` returns `'Impact 5'`.
String mapKeyword(Keyword keyword, String value) {
  final value = camelToTitleCase(keyword.name);
  if (value.endsWith(' X')) {
    return '${value.substring(0, value.length - 2)} $value';
  }
  return value;
}
