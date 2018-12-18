import 'package:built_collection/built_collection.dart';
import 'package:flutter/material.dart';
import 'package:hquplink/common.dart';
import 'package:swlegion/swlegion.dart';

class DetailsUnitPage extends StatelessWidget {
  static const _lightSidePrimary = Color(0xFF833C34);
  static const _darkSidePrimary = Color(0xFF42556C);

  final Unit unit;

  const DetailsUnitPage(this.unit);

  @override
  build(context) {
    final factionColor = unit.faction == Faction.lightSide
        ? _lightSidePrimary
        : _darkSidePrimary;
    final categories = [
      _DetailCategory(
        title: 'Details',
        children: [
          _DetailUnitDetails(unit),
        ],
      ),
      _DetailCategory(
        title: 'Upgrades',
        children: [
          _DetailUnitSlots(unit.upgrades),
        ],
      ),
    ];
    if (unit.keywords.isNotEmpty) {
      categories.add(_DetailCategory(
        title: 'Keywords',
        children: [
          _DetailUnitKeywords(unit.keywords),
        ],
      ));
    }
    if (unit.weapons.isNotEmpty) {
      categories.add(_DetailCategory(
        title: 'Weapons',
        children: [
          _DetailUnitWeapons(unit.weapons),
        ],
      ));
    }
    return Scaffold(
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            pinned: true,
            expandedHeight: 128,
            backgroundColor: factionColor,
            flexibleSpace: FlexibleSpaceBar(
              title: Container(
                child: Text(
                  unit.name,
                  textScaleFactor: 0.8,
                ),
              ),
              background: Stack(
                children: [
                  Container(
                    child: Image.asset(
                      'assets/faction.${unit.faction.name}.png',
                      fit: BoxFit.scaleDown,
                      color: Color.lerp(
                        factionColor,
                        Colors.white,
                        0.25,
                      ),
                    ),
                    padding: const EdgeInsets.fromLTRB(0, 20, 0, 20),
                  ),
                  const DecoratedBox(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment(0.0, -1.0),
                        end: Alignment(0.0, -0.4),
                        colors: <Color>[Color(0x60000000), Color(0x00000000)],
                      ),
                    ),
                  ),
                ],
                fit: StackFit.expand,
              ),
            ),
          ),
          SliverList(
            delegate: SliverChildListDelegate(categories),
          ),
        ],
      ),
    );
  }
}

class _DetailCategory extends StatelessWidget {
  final List<Widget> children;
  final String title;

  const _DetailCategory({
    @required this.children,
    @required this.title,
  });

  @override
  build(context) {
    final theme = Theme.of(context);
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 16),
      decoration: BoxDecoration(
        border: Border(
          bottom: BorderSide(color: theme.dividerColor),
        ),
      ),
      child: DefaultTextStyle(
        style: theme.textTheme.subhead,
        child: SafeArea(
          top: false,
          bottom: false,
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      child: Text(
                        title,
                        style: theme.textTheme.title,
                      ),
                      padding: const EdgeInsets.fromLTRB(16, 0, 0, 8),
                    )
                  ]..addAll(children),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _DetailUnitDetails extends StatelessWidget {
  static String _capitalize(String input) {
    return input[0].toUpperCase() + input.substring(1);
  }

  final Unit unit;

  const _DetailUnitDetails(
    this.unit,
  );

  @override
  build(_) {
    final children = [
      _DetailUnitPair(
        name: 'Type',
        value: camelToTitleCase(unit.type.name),
      ),
      _DetailUnitPair(
        name: 'Rank',
        value: camelToTitleCase(unit.rank.name),
      ),
      _DetailUnitPair(
        name: 'Points',
        value: '${unit.points}',
      ),
      _DetailUnitPair(
        name: 'Miniatures',
        value: '${unit.miniatures}',
      ),
      _DetailUnitPair(
        name: 'Wounds',
        value: '${unit.wounds}',
      ),
    ];
    final isVehicle = const [
      UnitType.repulsorVehicle,
      UnitType.groundVehicle,
    ].contains(unit.type);
    if (isVehicle) {
      children.add(_DetailUnitPair(
        name: 'Resilience',
        value: '${unit.resilience ?? '-'}',
      ));
    } else {
      children.add(_DetailUnitPair(
        name: 'Courage',
        value: '${unit.courage ?? '-'}',
      ));
    }
    children.addAll([
      _DetailUnitPair(
        name: 'Attack Surge',
        value: unit.attackSurge != null
            ? _capitalize(unit.attackSurge.name)
            : 'None',
      ),
      _DetailUnitPair(
        name: 'Speed',
        value: '${unit.speed}',
      ),
      _DetailUnitPair(
        name: 'Defense Dice',
        value: camelToTitleCase(unit.defense.name),
      ),
      _DetailUnitPair(
        name: 'Defense Surge',
        value: unit.hasDefenseSurge ? 'Yes' : 'No',
      ),
    ]);
    return Column(
      children: children,
    );
  }
}

class _DetailUnitSlots extends StatelessWidget {
  final BuiltMap<UpgradeSlot, int> upgrades;

  const _DetailUnitSlots(
    this.upgrades,
  );

  @override
  build(context) {
    return Column(
      children: upgrades.entries.map((slot) {
        return _DetailUnitPair(
          name: camelToTitleCase(slot.key.name),
          value: '${slot.value}',
        );
      }).toList(),
    );
  }
}

String _keywordToText(MapEntry<Keyword, String> word) {
  final value = camelToTitleCase(word.key.name);
  if (value.endsWith(' X')) {
    return '${value.substring(0, value.length - 2)} ${word.value}';
  }
  return value;
}

class _DetailUnitKeywords extends StatelessWidget {
  final BuiltMap<Keyword, String> keywords;

  const _DetailUnitKeywords(
    this.keywords,
  );

  @override
  build(context) {
    final theme = Theme.of(context);
    return Column(
      children: keywords.entries.map((word) {
        return Padding(
          child: Column(
            children: [
              Row(
                children: [
                  Text(_keywordToText(word)),
                ],
              ),
              Row(
                children: [
                  Flexible(
                    child: Text(
                      word.key.description,
                      style: theme.textTheme.caption,
                      softWrap: true,
                    ),
                  )
                ],
              ),
            ],
          ),
          padding: const EdgeInsets.symmetric(
            horizontal: 16,
            vertical: 8,
          ),
        );
      }).toList(),
    );
  }
}

class _DetailUnitWeapons extends StatelessWidget {
  final BuiltSet<Weapon> weapons;

  const _DetailUnitWeapons(this.weapons);

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
              : Text(weapon.keywords.entries.map(_keywordToText).join(', ')),
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

class _DetailUnitPair extends StatelessWidget {
  final String name;
  final String value;

  const _DetailUnitPair({
    @required this.name,
    @required this.value,
  });

  @override
  build(context) {
    final theme = Theme.of(context);
    return Container(
      child: Column(
        children: [
          Row(
            children: [
              Text(name, style: theme.textTheme.body1),
            ],
          ),
          Row(
            children: [
              Text(value, style: theme.textTheme.body2),
            ],
          ),
        ],
        mainAxisAlignment: MainAxisAlignment.start,
      ),
      padding: const EdgeInsets.symmetric(
        horizontal: 16,
        vertical: 8,
      ),
    );
  }
}
