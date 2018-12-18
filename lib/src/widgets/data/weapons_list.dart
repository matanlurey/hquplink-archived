import 'package:flutter/material.dart';
import 'package:hquplink/common.dart';
import 'package:swlegion/swlegion.dart';

/// Displays a list of [Weapon]s with some statistics.
class WeaponsList extends StatelessWidget {
  final Iterable<Weapon> weapons;

  const WeaponsList({
    @required this.weapons,
  });

  @override
  build(context) {
    final theme = Theme.of(context);
    return Column(
      children: weapons.map((weapon) {
        final diceText = weapon.dice.entries.map((dice) {
          final name = dice.key.name[0].toUpperCase();
          return TextSpan(
            children: [
              TextSpan(
                text: '$name ',
                style: TextStyle(
                  color: theme.textTheme.caption.color,
                ),
              ),
              TextSpan(
                text: '${dice.value} ',
              ),
            ],
          );
        });
        return ListTile(
          title: Text(weapon.name),
          subtitle: weapon.keywords.isEmpty
              ? null
              : Text(weapon.keywords.entries
                  .map((word) => mapKeyword(word.key, word.value))
                  .join(', ')),
          leading: Text(
            weapon.maxRange == 0
                ? 'Melee'
                : '${weapon.minRange} - ${weapon.maxRange}',
            style: TextStyle(
              color: theme.textTheme.caption.color,
            ),
          ),
          trailing: Text.rich(
            TextSpan(
              children: diceText.toList(),
            ),
          ),
        );
      }).toList(),
    );
  }
}
