import 'package:flutter/material.dart';
import 'package:swlegion/swlegion.dart';

class FactionIcon extends StatelessWidget {
  final Faction faction;
  final double width;
  final double height;
  final Color color;
  final BoxFit fit;

  const FactionIcon(
    this.faction, {
    this.width,
    this.height,
    this.color,
    this.fit,
  }) : assert(faction != null);

  @override
  build(_) {
    return Image.asset(
      'assets/factions/${faction.name.toLowerCase()}.png',
      width: width,
      height: height,
      fit: fit,
      color: color ?? (faction == Faction.darkSide ? Colors.white : Colors.red),
    );
  }
}
