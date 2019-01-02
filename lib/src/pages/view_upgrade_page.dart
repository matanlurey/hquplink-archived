import 'package:flutter/material.dart';
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
    final theme = Theme.of(context);
    return Scaffold(
      appBar: AppBar(
        title: Text(toTitleCase(upgrade.name)),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Center(
          child: Text(
            collapseWhitespace(upgrade.text),
            textAlign: TextAlign.center,
            style: theme.textTheme.display1,
          ),
        ),
      ),
    );
  }
}
