import 'package:flutter/material.dart';
import 'package:hquplink/common.dart';
import 'package:hquplink/widgets.dart';
import 'package:swlegion/swlegion.dart';

import '../routes.dart';
import '../services/catalog.dart';

class BrowseUpgradesPage extends StatelessWidget {
  const BrowseUpgradesPage();

  @override
  build(context) {
    final catalog = Catalog.of(context);
    return Scaffold(
      appBar: AppBar(
        title: const Text('Upgrades'),
      ),
      body: ListView(
        children: ListTile.divideTiles(
          context: context,
          tiles: catalog.upgrades.map((upgrade) {
            return ListTile(
              leading: UpgradeAvatar(upgrade),
              title: Text(
                upgrade.name,
                overflow: TextOverflow.ellipsis,
              ),
              subtitle: Text(camelToTitleCase(upgrade.type.name)),
              trailing: upgrade.restrictedToUnit.isNotEmpty
                  ? UnitAvatar(upgrade.restrictedToUnit.first)
                  : upgrade.restrictedToFaction != null
                      ? Image.asset(
                          'assets/faction.${upgrade.restrictedToFaction.name}.png',
                          width: 40,
                          color:
                              upgrade.restrictedToFaction == Faction.lightSide
                                  ? Colors.red
                                  : null,
                        )
                      : upgrade.restrictedToType != null
                          ? Text(upgrade.restrictedToType.name)
                          : null,
              onTap: () {
                Navigator.pushNamed(
                  context,
                  '${detailsUpgradesPage.name}/${upgrade.id}',
                );
              },
            );
          }).toList(),
        ).toList(),
      ),
    );
  }
}
