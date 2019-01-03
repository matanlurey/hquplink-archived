import 'package:flutter/material.dart' hide Simulation;
import 'package:hquplink/models.dart';
import 'package:hquplink/pages.dart';
import 'package:hquplink/widgets.dart';

class ViewWeaponPage extends StatelessWidget {
  static void navigateTo(BuildContext context, WeaponView weapon) {
    Navigator.push(
      context,
      MaterialPageRoute<void>(
        builder: (_) => ViewWeaponPage(weapon: weapon),
        fullscreenDialog: true,
      ),
    );
  }

  final WeaponView weapon;

  /// See [navigateTo] for actual in-app use.
  @visibleForTesting
  ViewWeaponPage({
    @required this.weapon,
  })  : assert(weapon != null),
        super(key: Key(weapon.name));

  @override
  build(_) {
    return Scaffold(
      appBar: AppBar(
        title: Text(toTitleCase(weapon.name)),
        actions: [
          Builder(
            builder: (context) {
              return IconButton(
                icon: const Icon(Icons.casino),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute<void>(
                      builder: (_) {
                        return DiceSimulatorPage(
                          initialData: Simulation((b) => b),
                        );
                      },
                      fullscreenDialog: true,
                    ),
                  );
                },
              );
            },
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: ListView(
          children: [
            Card(
              child: ViewDataCard(
                title: const Text('Details'),
                subtitle: Text('${weapon.miniatures} Units'),
                trailing: DiceDisplay(
                  display: weapon.dice,
                ),
                body: SimpleDataGrid(
                  data: {
                    'Range': Text(weapon.range),
                  },
                ),
              ),
            ),
            _buildKeywordTile(),
          ],
        ),
      ),
    );
  }

  Widget _buildKeywordTile() {
    if (weapon.keywords.isEmpty) {
      return Container();
    }
    return Card(
      child: ViewDataCard(
        title: const Text('Keywords'),
        body: KeywordsList(keywords: weapon.keywords),
      ),
    );
  }
}
