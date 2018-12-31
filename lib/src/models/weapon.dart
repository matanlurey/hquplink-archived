import 'package:built_collection/built_collection.dart';
import 'package:hquplink/models.dart';
import 'package:hquplink/services.dart';
import 'package:meta/meta.dart';

/// View model for a [Weapon] to display in the UI.
class WeaponView {
  static Iterable<WeaponView> all(Catalog catalog, ArmyUnit unit) sync* {
    // Built-in weapons.
    final details = catalog.toUnit(unit.unit);
    yield* details.weapons.map((w) => WeaponView.fromBuiltIn(catalog, unit, w));

    final upgrades = unit.upgrades.map(catalog.toUpgrade);
    yield* upgrades.where((u) => u.weapon != null).map((u) {
      return WeaponView.fromUpgrade(catalog, unit, u);
    });
  }

  /// Name of the weapon.
  final String name;

  /// Formatted range of the weapon.
  final String range;

  /// Formatted keywords of the weapon.
  final String keyword;

  /// Number of miniatures that carry this weapon.
  final int miniatures;

  /// Attack dice of the weapon.
  final List<AttackDice> dice;

  const WeaponView._({
    @required this.name,
    @required this.range,
    @required this.keyword,
    @required this.miniatures,
    @required this.dice,
  });

  @override
  bool operator ==(Object o) => o is WeaponView && o.name == name;

  @override
  int get hashCode => name.hashCode;

  /// Create a built-in weapon.
  factory WeaponView.fromBuiltIn(
    Catalog catalog,
    ArmyUnit unit,
    Weapon weapon,
  ) {
    final details = catalog.toUnit(unit.unit);
    final upgrades = unit.upgrades.map(catalog.toUpgrade);
    final added = upgrades.where((u) => u.addsMiniature);

    var totalMinisWithWeapon = details.miniatures + added.length;
    // EXCEPTION: The "Sidearm: X" keyword *removes* a built-in weapon of the X
    // type or range supplied. The one known unit with this keyword so far is
    // the IRG with "Sidearm: Melee", so we can hard-code that for now.
    if (weapon.maxRange == 0 && _hasSidearmMelee(upgrades)) {
      totalMinisWithWeapon--;
    }

    return WeaponView._(
      name: weapon.name,
      range: formatRange(weapon),
      keyword: formatKeywords(weapon.keywords).join(', '),
      miniatures: totalMinisWithWeapon,
      dice: flattenDice(weapon.dice),
    );
  }

  static bool _hasSidearmMelee(Iterable<Upgrade> upgrades) {
    return upgrades.any((u) {
      return u.keywords[Keyword.sidearmX]?.toLowerCase() == 'melee';
    });
  }

  /// Creates an upgrade weapon.
  factory WeaponView.fromUpgrade(
    Catalog catalog,
    ArmyUnit unit,
    Upgrade upgrade,
  ) {
    final details = catalog.toUnit(unit.unit);
    final upgrades = unit.upgrades.map(catalog.toUpgrade);
    final added = upgrades.where((u) => u.addsMiniature);
    final weapon = upgrade.weapon;
    assert(weapon != null);

    final totalMinis = details.miniatures + added.length;
    final withWeapon = upgrade.addsMiniature ? 1 : totalMinis;

    return WeaponView._(
      name: weapon.name,
      range: formatRange(weapon),
      keyword: formatKeywords(weapon.keywords).join(', '),
      dice: flattenDice(weapon.dice),
      miniatures: withWeapon,
    );
  }

  /// Returns a [keyword] with the value of `'X'` removed if necessary.
  ///
  /// For example, `formatKeyword(Keyword.impactX)` returns `'Impact'`.
  static String formatKeyword(Keyword keyword) {
    final word = toTitleCase(keyword.name).replaceAll('-', ' ');
    if (word.endsWith(' X')) {
      return '${word.substring(0, word.length - 2)}';
    }
    return word;
  }

  /// Returns [keywords] formatted with the value, if provided.
  static Iterable<String> formatKeywords(BuiltMap<Keyword, String> keywords) {
    return keywords.entries.map((e) {
      var text = formatKeyword(e.key);
      if (e.value.isNotEmpty) {
        text += ' ${e.value}';
      }
      return text;
    });
  }

  /// Returns formatted text for the range of a [weapon].
  static String formatRange(Weapon weapon) {
    if (weapon.maxRange == 0) {
      return 'Melee';
    }
    final min = weapon.minRange == 0 ? 'Melee' : '${weapon.minRange}';
    final max = weapon.maxRange == null ? '∞' : '${weapon.maxRange}';
    return '$min - $max';
  }

  /// Flattens a [dice] map.
  static List<AttackDice> flattenDice(BuiltMap<AttackDice, int> dice) {
    return dice.entries
        .map((e) {
          final results = <AttackDice>[];
          for (var i = 0; i < e.value; i++) {
            results.add(e.key);
          }
          return results;
        })
        .expand((i) => i)
        .toList();
  }

  static final _titleMatcher = RegExp(r'[_.\- ]+(\w|$)');

  /// Converts `'hyphen-case'` to `'Title Case'`.
  static String toTitleCase(String input) {
    final result = input.replaceAllMapped(
      _titleMatcher,
      (m) => m.group(0).toUpperCase(),
    );
    return result[0].toUpperCase() + result.substring(1);
  }
}
