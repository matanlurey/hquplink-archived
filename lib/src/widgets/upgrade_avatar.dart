import 'package:flutter/material.dart';
import 'package:hquplink/common.dart';
import 'package:swlegion/swlegion.dart';

class UpgradeAvatar extends StatelessWidget {
  static final _colors = [
    Colors.red,
    Colors.blue,
    Colors.green,
    Colors.yellow,
    Colors.purple,
    Colors.pink,
  ];

  final Upgrade upgrade;

  const UpgradeAvatar(this.upgrade) : assert(upgrade != null);

  @override
  build(context) {
    return CircleAvatar(
      backgroundColor: Color.lerp(
          _colors[upgrade.hashCode % _colors.length], Colors.white, 0.3),
      child: Text(abbreviate(camelToTitleCase(upgrade.name))),
    );
  }
}
