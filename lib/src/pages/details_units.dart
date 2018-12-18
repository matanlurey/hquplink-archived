import 'package:flutter/material.dart';
import 'package:hquplink/common.dart';
import 'package:hquplink/widgets.dart';
import 'package:swlegion/swlegion.dart';

import '../routes.dart';
import '../services/catalog.dart';

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
      DataPanel(
        title: const Text('Details'),
        body: _DetailUnitDetails(unit),
      ),
      DataPanel(
        title: const Text('Upgrades'),
        body: _DetailUnitSlots(unit),
      ),
    ];
    if (unit.keywords.isNotEmpty) {
      categories.add(DataPanel(
        title: const Text('Keywords'),
        body: KeywordsList(keywords: unit.keywords),
      ));
    }
    if (unit.weapons.isNotEmpty) {
      categories.add(DataPanel(
        title: const Text('Weapons'),
        body: WeaponsList(weapons: unit.weapons),
      ));
    }
    final title = Text(
      unit.name,
      textScaleFactor: 0.8,
    );
    final subTitle = unit.subTitle != null
        ? Text(
            unit.subTitle,
            textScaleFactor: 0.5,
          )
        : null;
    return Scaffold(
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            pinned: true,
            expandedHeight: 128,
            backgroundColor: factionColor,
            flexibleSpace: FlexibleSpaceBar(
              title: Column(
                children: subTitle != null ? [title, subTitle] : [title],
                mainAxisAlignment: MainAxisAlignment.end,
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
      DataPair(
        title: const Text('Type'),
        value: Text(camelToTitleCase(unit.type.name)),
      ),
      DataPair(
        title: const Text('Rank'),
        value: Text(camelToTitleCase(unit.rank.name)),
      ),
      DataPair(
        title: const Text('Points'),
        value: Text('${unit.points}'),
      ),
      DataPair(
        title: const Text('Miniatures'),
        value: Text('${unit.miniatures}'),
      ),
      DataPair(
        title: const Text('Miniatures'),
        value: Text('${unit.wounds}'),
      ),
    ];
    final isVehicle = const [
      UnitType.repulsorVehicle,
      UnitType.groundVehicle,
    ].contains(unit.type);
    if (isVehicle) {
      children.add(DataPair(
        title: const Text('Resilience'),
        value: Text('${unit.resilience ?? '-'}'),
      ));
    } else {
      children.add(DataPair(
        title: const Text('Courage'),
        value: Text('${unit.courage ?? '-'}'),
      ));
    }
    children.addAll([
      DataPair(
        title: const Text('Attack Surge'),
        value: Text(unit.attackSurge != null
            ? _capitalize(unit.attackSurge.name)
            : 'None'),
      ),
      DataPair(
        title: const Text('Speed'),
        value: Text('${unit.speed}'),
      ),
      DataPair(
        title: const Text('Defense Dice'),
        value: Text(camelToTitleCase(unit.defense.name)),
      ),
      DataPair(
        title: const Text('Defense Surge'),
        value: Text(unit.hasDefenseSurge ? 'Yes' : 'No'),
      ),
    ]);
    return Padding(
      child: GridView.count(
        padding: const EdgeInsets.all(0),
        children: children,
        shrinkWrap: true,
        primary: false,
        crossAxisCount: 2,
        childAspectRatio: 3,
      ),
      padding: const EdgeInsets.symmetric(horizontal: 16),
    );
  }
}

class _DetailUnitSlots extends StatelessWidget {
  final Unit unit;

  const _DetailUnitSlots(
    this.unit,
  );

  @override
  build(context) {
    final catalog = Catalog.of(context);
    final upgrades = catalog.validUpgrades(unit);
    return Column(
      children: upgrades.toMap().entries.map((entry) {
        return ExpansionTile(
          title: Row(
            children: [
              Expanded(
                flex: 2,
                child: Text(camelToTitleCase(entry.key.name)),
              ),
              Expanded(
                flex: 3,
                child: Text(
                  '${unit.upgrades[entry.key]}',
                  textAlign: TextAlign.end,
                ),
              )
            ],
          ),
          children: entry.value.map((upgrade) {
            return ListTile(
              title: InkWell(
                child: Text(upgrade.name),
                onTap: () {
                  Navigator.pushNamed(
                    context,
                    '${detailsUpgradesPage.name}/${upgrade.id}',
                  );
                },
              ),
            );
          }).toList(),
        );
      }).toList(),
    );
  }
}
