import 'package:flutter/material.dart';
import 'package:hquplink/models.dart';
import 'package:hquplink/pages.dart';
import 'package:hquplink/widgets.dart';

/// Displays details about the view model of a [weapon].
class WeaponListTile extends StatelessWidget {
  final WeaponView weapon;

  WeaponListTile({
    @required this.weapon,
  })  : assert(weapon != null),
        super(key: Key(weapon.name));

  @override
  build(context) {
    var subtitle = weapon.range;
    if (weapon.keywords.isNotEmpty) {
      subtitle = '$subtitle: ${weapon.keywordList}';
    }
    return ListTile(
      title: Text(
        weapon.name,
        overflow: TextOverflow.ellipsis,
      ),
      contentPadding: const EdgeInsets.all(0),
      trailing: DiceDisplay(display: weapon.dice),
      subtitle: Text(subtitle),
      onTap: () => ViewWeaponPage.navigateTo(context, weapon),
    );
  }
}

class DiceDisplay extends StatelessWidget {
  final Iterable<AttackDice> display;

  const DiceDisplay({
    @required this.display,
  }) : assert(display != null);

  @override
  build(_) {
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
