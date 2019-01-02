import 'package:flutter/material.dart';
import 'package:hquplink/models.dart';
import 'package:hquplink/services.dart';
import 'package:hquplink/widgets.dart';
import 'package:swlegion/swlegion.dart';

class ViewUpgradePage extends StatelessWidget {
  static void navigateTo(BuildContext context, Reference<Upgrade> upgrade) {
    Navigator.push(
      context,
      MaterialPageRoute<void>(
        builder: (context) {
          return ViewUpgradePage(
            upgrade: getCatalog(context).toUpgrade(upgrade),
          );
        },
        fullscreenDialog: true,
      ),
    );
  }

  final Upgrade upgrade;

  /// See [navigateTo] for actual in-app use.
  @visibleForTesting
  ViewUpgradePage({
    @required this.upgrade,
  })  : assert(upgrade != null),
        super(key: Key(upgrade.name));

  @override
  build(context) {
    final data = {
      'Points': Text('${upgrade.points}'),
      'Exhaustible': Text(upgrade.isExhaustible ? 'Yes' : 'No'),
      'Restrictions': Text(() {
        if (upgrade.restrictedToFaction != null) {
          return const {
            Faction.lightSide: 'Light Side',
            Faction.darkSide: 'Dark Side',
          }[upgrade.restrictedToFaction];
        }
        if (upgrade.restrictedToUnit.isNotEmpty) {
          final catalog = getCatalog(context);
          return upgrade.restrictedToUnit
              .map(catalog.toUnit)
              .map((u) => u.name)
              .toSet()
              .join(', ');
        }
        return 'None';
      }()),
    };
    return Scaffold(
      appBar: AppBar(
        title: Text(toTitleCase(upgrade.name)),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: ListView(
          children: [
            Card(
              child: ViewDataCard(
                title: const Text('Details'),
                subtitle: Text(toTitleCase(upgrade.type.name)),
                trailing: UpgradeAvatar(upgrade),
                body: SimpleDataGrid(
                  data: data,
                ),
              ),
            ),
            _buildKeywordTile(),
            _buildDetailTile(),
          ],
        ),
      ),
    );
  }

  Widget _buildKeywordTile() {
    if (upgrade.keywords.isEmpty) {
      return Container();
    }
    return Card(
      child: ViewDataCard(
        title: const Text('Keywords'),
        body: KeywordsList(keywords: upgrade.keywords),
      ),
    );
  }

  Widget _buildDetailTile() {
    if (upgrade.weapon == null) {
      return Card(
        child: ViewDataCard(
          title: const Text('Text'),
          body: Text(collapseWhitespace(upgrade.text)),
        ),
      );
    }
    return Card(
      child: ViewDataCard(
        title: const Text('Weapon'),
        body: WeaponListTile(
          weapon: WeaponView(upgrade.weapon),
        ),
      ),
    );
  }
}
