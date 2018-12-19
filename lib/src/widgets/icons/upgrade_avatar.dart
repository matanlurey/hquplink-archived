import 'package:flutter/material.dart';
import 'package:swlegion/swlegion.dart';

/// Draws a [CircleAvatar] for the portrait of the provided [upgrade].
class UpgradeAvatar extends StatelessWidget {
  final Upgrade upgrade;

  const UpgradeAvatar(this.upgrade) : assert(upgrade != null);

  @override
  build(context) {
    return CircleAvatar(
      backgroundImage:
          AssetImage('assets/upgrades/${upgrade.id.toLowerCase()}.png'),
    );
  }
}
