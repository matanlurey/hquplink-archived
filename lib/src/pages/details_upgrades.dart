import 'package:flutter/material.dart';
import 'package:hquplink/common.dart';
import 'package:hquplink/widgets.dart';
import 'package:swlegion/swlegion.dart';

class DetailsUpgradePage extends StatelessWidget {
  final Upgrade upgrade;

  const DetailsUpgradePage(this.upgrade);

  @override
  build(context) {
    final children = <Widget>[
      DataPanel(
        title: const Text('Details'),
        body: Padding(
          child: GridView.count(
            padding: const EdgeInsets.all(0),
            shrinkWrap: true,
            primary: false,
            crossAxisCount: 2,
            childAspectRatio: 3,
            children: [
              DataPair(
                title: const Text('Type'),
                value: Text(camelToTitleCase(upgrade.type.name)),
              ),
              DataPair(
                title: const Text('Points'),
                value: Text('${upgrade.points}'),
              ),
              DataPair(
                title: const Text('Restrictions'),
                value: Text(upgrade.restrictedToFaction != null
                    ? camelToTitleCase(upgrade.restrictedToFaction.name)
                    : upgrade.restrictedToUnit != null
                        ? upgrade.restrictedToUnit.name
                        : 'None'),
              ),
              DataPair(
                title: const Text('Exhaustible'),
                value: Text(upgrade.isExhaustible ? 'Yes' : 'No'),
              ),
              DataPair(
                title: const Text('Adds Minis'),
                value: Text(upgrade.addsMiniature ? 'Yes' : 'No'),
              ),
            ],
          ),
          padding: const EdgeInsets.symmetric(horizontal: 16),
        ),
      )
    ];
    if (upgrade.text.isNotEmpty) {
      children.insert(
        0,
        DataPanel(
          title: const Text('Text'),
          body: Padding(
            child: Text(upgrade.text.trim()),
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          ),
        ),
      );
    }
    if (upgrade.keywords.isNotEmpty) {
      children.add(
        DataPanel(
          title: const Text('Keywords'),
          body: KeywordsList(keywords: upgrade.keywords),
        ),
      );
    }
    if (upgrade.weapon != null) {
      children.add(
        DataPanel(
          title: const Text('Weapons'),
          body: WeaponsList(weapons: [upgrade.weapon]),
        ),
      );
    }
    return Scaffold(
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            pinned: true,
            expandedHeight: 128,
            flexibleSpace: FlexibleSpaceBar(
              title: Container(
                child: Text(
                  upgrade.name,
                  textScaleFactor: 0.8,
                ),
              ),
            ),
          ),
          SliverList(
            delegate: SliverChildListDelegate(children),
          ),
        ],
      ),
    );
  }
}
