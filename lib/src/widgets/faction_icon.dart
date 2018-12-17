import 'package:flutter/material.dart';
import 'package:swlegion/swlegion.dart';

class FactionIcon extends StatelessWidget {
  final Faction faction;

  const FactionIcon(this.faction) : assert(faction != null);

  @override
  build(_) {
    return Image.asset(
      'assets/faction.${faction.name}.png',
      color: faction == Faction.lightSide ? const Color(0xFF833C34) : null,
      width: 36,
      height: 36,
    );
  }
}
