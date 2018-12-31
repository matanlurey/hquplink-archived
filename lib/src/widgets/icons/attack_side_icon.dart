import 'package:flutter/material.dart';
import 'package:swlegion/swlegion.dart';

class AttackSideIcon extends StatelessWidget {
  final AttackDiceSide side;
  final double width;
  final double height;
  final Color color;
  final BoxFit fit;

  const AttackSideIcon(
    this.side, {
    this.width,
    this.height,
    this.color,
    this.fit,
  });

  @override
  build(_) {
    final icon = const {
      AttackDiceSide.hit: 'hit',
      AttackDiceSide.criticalHit: 'critical',
      AttackDiceSide.surge: 'surge',
    }[side];
    return Image.asset(
      'assets/dice/attack/$icon.png',
      width: width,
      height: height,
      fit: fit,
      color: color,
    );
  }
}
