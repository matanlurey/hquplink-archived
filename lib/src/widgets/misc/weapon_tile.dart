import 'package:flutter/material.dart';
import 'package:hquplink/models.dart';
import 'package:hquplink/widgets.dart';

/// Displays details about the view model of a [weapon].
class WeaponListTile extends StatelessWidget {
  final WeaponView weapon;

  WeaponListTile({
    @required this.weapon,
  })  : assert(weapon != null),
        super(key: Key(weapon.name));

  @override
  build(_) {
    var subtitle = '(${weapon.miniatures}) ${weapon.range}';
    if (weapon.keyword.isNotEmpty) {
      subtitle = '$subtitle: ${weapon.keyword}';
    }
    return ListTile(
      title: Text(
        weapon.name,
        overflow: TextOverflow.ellipsis,
      ),
      contentPadding: const EdgeInsets.all(0),
      trailing: _buildDice(weapon.dice),
      subtitle: Text(subtitle),
    );
  }

  Widget _buildDice(Iterable<AttackDice> display) {
    final dice = display.map((d) {
      return Padding(
        padding: const EdgeInsets.only(right: 8),
        child: SizedBox(
          width: 10,
          height: 10,
          child: AttackDiceIcon(dice: d),
        ),
      );
    }).toList();
    return Column(
      children: [
        Row(
          children: dice.take(3).toList(),
          mainAxisSize: MainAxisSize.min,
        ),
        Padding(
          padding: EdgeInsets.only(top: dice.length > 3 ? 8 : 0),
          child: Row(
            children: dice.skip(3).toList(),
            mainAxisSize: MainAxisSize.min,
          ),
        ),
      ],
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.end,
    );
  }
}
