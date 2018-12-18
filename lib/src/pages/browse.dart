import 'dart:math' as math;

import 'package:built_collection/built_collection.dart';
import 'package:flutter/material.dart';
import 'package:hquplink/common.dart';
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
        title: const Text('Keywords'),
      ),
      body: ListView(
        children: ListTile.divideTiles(
          color: theme.dividerColor,
          tiles: keywords.map((keyword) {
            return ListTile(
              title: Text(camelToTitleCase(keyword.name)),
              subtitle: Text(keyword.description),
            );
          }).toList(),
        ).toList(),
      ),
    );
  }
}

class BrowseUpgradesPage extends StatelessWidget {
  const BrowseUpgradesPage();

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
          tiles: catalog.upgrades.map((upgrade) {
            var faction = upgrade.restrictedToFaction;
            faction ??= upgrade.restrictedToUnit?.faction;
            return ListTile(
              leading: faction != null
                  ? Image.asset(
                      'assets/faction.${faction.name}.png',
                      width: 24,
                      height: 24,
                      color: faction == Faction.lightSide ? Colors.red : null,
                    )
                  : const SizedBox(width: 24, height: 24),
              title: Text(
                upgrade.name,
                overflow: TextOverflow.ellipsis,
              ),
              trailing: Column(
                children: [
                  Text(
                    const {
                      UpgradeSlot.command: 'Command',
                      UpgradeSlot.comms: 'Comms',
                      UpgradeSlot.elite: 'Elite',
                      UpgradeSlot.force: 'Force',
                      UpgradeSlot.gear: 'Gear',
                      UpgradeSlot.generator: 'Generator',
                      UpgradeSlot.grenades: 'Grenades',
                      UpgradeSlot.hardPoint: 'Hard Point',
                      UpgradeSlot.heavyWeapon: 'Heavy Weapon',
                      UpgradeSlot.personnel: 'Personnel',
                      UpgradeSlot.pilot: 'Pilot',
                    }[upgrade.type],
                    style: const TextStyle(
                      color: Colors.black87,
                      fontSize: 10,
                    ),
                  ),
                  Text(
                    '${upgrade.points} Points',
                    style: const TextStyle(
                      fontSize: 12,
                    ),
                  ),
                ],
                crossAxisAlignment: CrossAxisAlignment.end,
              ),
            );
          }),
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
