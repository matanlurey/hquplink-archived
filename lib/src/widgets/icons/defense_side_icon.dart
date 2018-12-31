import 'package:flutter/material.dart';
import 'package:swlegion/swlegion.dart';

class DefenseSideIcon extends StatelessWidget {
  final DefenseDiceSide side;
  final double width;
  final double height;
  final Color color;
  final BoxFit fit;

  const DefenseSideIcon(
    this.side, {
    this.width,
    this.height,
    this.color,
    this.fit,
  });

  @override
  build(_) {
    final icon = const {
      DefenseDiceSide.block: 'block',
      DefenseDiceSide.surge: 'surge',
    }[side];
    return Image.asset(
      'assets/dice/defense/$icon.png',
      width: width,
      height: height,
      fit: fit,
      color: color,
    );
  }
}
