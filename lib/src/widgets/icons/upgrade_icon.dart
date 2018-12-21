import 'package:flutter/material.dart';
import 'package:swlegion/swlegion.dart';

class UpgradeAvatar extends StatelessWidget {
  final Upgrade upgrade;

  const UpgradeAvatar(this.upgrade);

  @override
  build(_) {
    return CircleAvatar(
      backgroundImage: AssetImage(
        'assets/upgrades/${upgrade.id.toLowerCase()}.png',
      ),
    );
  }
}
