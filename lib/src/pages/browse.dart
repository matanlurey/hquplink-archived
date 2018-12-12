import 'dart:math' as math;

import 'package:built_collection/built_collection.dart';
import 'package:flutter/material.dart';
import 'package:swlegion/swlegion.dart';

import '../routes.dart';
import '../services/catalog.dart';

class BrowsePage extends StatelessWidget {
  const BrowsePage();

  @override
  build(context) {
    final dividerColor = Theme.of(context).dividerColor;
    return ListView(
      children: ListTile.divideTiles(
        color: dividerColor,
        tiles: [
          ListTile(
            leading: const Icon(Icons.list),
            trailing: const Icon(Icons.arrow_right),
            title: const Text('Keywords'),
            onTap: () {
              Navigator.pushNamed(context, browseKeywordsPage.name);
            },
          ),
          ListTile(
            leading: const Icon(Icons.list),
            trailing: const Icon(Icons.arrow_right),
            title: const Text('Units'),
            onTap: () {
              Navigator.pushNamed(context, browseUnitsPage.name);
            },
          ),
          ListTile(
            leading: const Icon(Icons.list),
            trailing: const Icon(Icons.arrow_right),
            title: const Text('Upgrades'),
            onTap: () {
              Navigator.pushNamed(context, browseUpgradesPage.name);
            },
          ),
          ListTile(
            leading: const Icon(Icons.list),
            trailing: const Icon(Icons.arrow_right),
            title: const Text('Weapons'),
            onTap: () {
              Navigator.pushNamed(context, browseWeaponsPage.name);
            },
          ),
        ],
      ).toList(),
    );
  }
}

class BrowseKeywordsPage extends StatelessWidget {
  const BrowseKeywordsPage();

  @override
  build(context) {
    final keywords = Keyword.values.toList()
      ..sort((a, b) => a.name.compareTo(b.name));
    final theme = Theme.of(context);
    return Scaffold(
      appBar: AppBar(
        title: const Text('Units'),
      ),
      body: ListView(
        children: ListTile.divideTiles(
          color: theme.dividerColor,
          tiles: keywords.map((keyword) {
            return ListTile(
              title: _renderName(keyword.name),
              subtitle: Text(keyword.description),
            );
          }).toList(),
        ).toList(),
      ),
    );
  }

  static Widget _renderName(String name) {
    bool isCapital(int character) => character < 97;
    final buffer = StringBuffer();
    for (var i = 0; i < name.length; i++) {
      final character = name.codeUnitAt(i);
      if (isCapital(character)) {
        buffer..write(' ')..write(String.fromCharCode(character));
      } else {
        var letter = String.fromCharCode(character);
        if (i == 0) {
          letter = letter.toUpperCase();
        }
        buffer.write(letter);
      }
    }
    return Text(buffer.toString());
  }
}

class BrowseUnitsPage extends StatelessWidget {
  const BrowseUnitsPage();

  @override
  build(context) {
    final catalog = Catalog.of(context);
    final theme = Theme.of(context);
    return Scaffold(
      appBar: AppBar(
        title: const Text('Units'),
      ),
      body: ListView(
        children: ListTile.divideTiles(
          color: theme.dividerColor,
          tiles: catalog.units.map((unit) {
            return ListTile(
              leading: Image.asset(
                'assets/faction.${unit.faction.name}.png',
                width: 24,
                height: 24,
                color: unit.faction == Faction.lightSide ? Colors.red : null,
              ),
              title: Text(
                unit.name,
                overflow: TextOverflow.ellipsis,
              ),
              trailing: Column(
                children: [
                  Text(
                    {
                      Rank.commander: 'Commander',
                      Rank.corps: 'Corps',
                      Rank.heavy: 'Heavy',
                      Rank.operative: 'Operative',
                      Rank.specialForces: 'Special Forces',
                      Rank.support: 'Support',
                    }[unit.rank],
                    style: const TextStyle(
                      color: Colors.black87,
                      fontSize: 10,
                    ),
                  ),
                  Text(
                    '${unit.points} Points',
                    style: const TextStyle(
                      fontSize: 12,
                    ),
                  ),
                ],
                crossAxisAlignment: CrossAxisAlignment.end,
              ),
              subtitle: unit.subTitle != null
                  ? Text(
                      unit.subTitle,
                      overflow: TextOverflow.ellipsis,
                    )
                  : null,
            );
          }),
        ).toList(),
      ),
    );
  }
}

class BrowseUpgradesPage extends StatelessWidget {
  const BrowseUpgradesPage();

  @override
  build(context) {
    final dividerColor = Theme.of(context).dividerColor;
    return Scaffold(
      appBar: AppBar(
        title: const Text('Upgrades'),
      ),
      body: ListView(
        children: ListTile.divideTiles(
          color: dividerColor,
          tiles: const [],
        ).toList(),
      ),
    );
  }
}

class BrowseWeaponsPage extends StatelessWidget {
  const BrowseWeaponsPage();

  @override
  build(context) {
    final catalog = Catalog.of(context);
    final dividerColor = Theme.of(context).dividerColor;
    return Scaffold(
      appBar: AppBar(
        title: const Text('Weapons'),
      ),
      body: ListView(
        children: ListTile.divideTiles(
          color: dividerColor,
          tiles: catalog.weapons.map((weapon) {
            final pierce = weapon.keywords[Keyword.pierceX];
            final impact = weapon.keywords[Keyword.impactX];
            return ListTile(
              title: Text(
                weapon.name,
                overflow: TextOverflow.ellipsis,
              ),
              leading: _renderDice(weapon.dice),
              trailing: Column(
                children: [
                  pierce != null
                      ? Text(
                          'Pierce $pierce',
                          style: const TextStyle(
                            fontSize: 12,
                          ),
                        )
                      : const Text(''),
                  impact != null
                      ? Text(
                          'Impact $impact',
                          style: const TextStyle(
                            fontSize: 12,
                          ),
                        )
                      : const Text(''),
                ],
                crossAxisAlignment: CrossAxisAlignment.end,
              ),
              subtitle: _renderRange(weapon.minRange, weapon.maxRange),
            );
          }),
        ).toList(),
      ),
    );
  }

  static Widget _renderRange(int min, int max) {
    if (min == 0 && max == 0) {
      return const Text('Melee');
    }
    final minRange = min == 0 ? 'Melee' : 'Range $min';
    final maxRange = max == null ? 'Unlimited' : '$max';
    return Text('$minRange to $maxRange');
  }

  static const double _degrees45InRadians = 45 * math.pi / 180;

  static Widget _renderDice(BuiltMap<AttackDice, int> dice) {
    final bestDice = (dice[AttackDice.red] ?? 0) > 0
        ? AttackDice.red
        : (dice[AttackDice.black] ?? 0) > 0
            ? AttackDice.black
            : AttackDice.white;
    return Stack(
      children: [
        Transform.rotate(
          child: _DicePoolIcon(const {
            AttackDice.red: Colors.red,
            AttackDice.black: Colors.black,
            AttackDice.white: Colors.white,
          }[bestDice]),
          angle: _degrees45InRadians,
        ),
        SizedBox(
          child: Center(
            child: Text(
              '${dice[bestDice]}${dice.values.length > 1 ? '+' : ''}',
              style: TextStyle(
                color:
                    bestDice == AttackDice.white ? Colors.black : Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          width: 24,
          height: 24,
        )
      ],
    );
  }
}

class _DicePoolIcon extends StatelessWidget {
  final Color color;

  const _DicePoolIcon(this.color);

  @override
  build(_) {
    return SizedBox(
      child: CustomPaint(
        painter: _DiceIconPainter(color),
      ),
      width: 24,
      height: 24,
    );
  }
}

class _DiceIconPainter extends CustomPainter {
  final Color color;

  const _DiceIconPainter(this.color);

  @override
  paint(Canvas canvas, Size size) {
    final rect = Rect.fromPoints(
      const Offset(0.0, 0.0),
      Offset(size.width, size.height),
    );
    final fill = Paint()
      ..color = color
      ..style = PaintingStyle.fill;
    final stroke = Paint()
      ..color = Colors.grey
      ..style = PaintingStyle.stroke;
    canvas..drawRect(rect, fill)..drawRect(rect, stroke);
  }

  @override
  shouldRepaint(CustomPainter oldDelegate) => false;
}
