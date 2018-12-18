bool _isCapitalized(int character) => character < 97;

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
