import 'package:flutter/material.dart';
import 'package:swlegion/swlegion.dart';

/// Creates an icon representing a side of an attack dice.
class AttackSideIcon extends StatelessWidget {
  /// Side to display.
  final AttackDiceSide side;

  /// Width of the icon.
  final double width;

  /// Height of the icon.
  final double height;

  /// Color override of the icon.
  final Color color;

  /// Fit option for the icon.
  final BoxFit fit;

  const AttackSideIcon({
    @required this.side,
    this.width,
    this.height,
    this.color,
    this.fit,
  }) : assert(side != null);

  @override
  build(_) {
    if (side == AttackDiceSide.blank) {
      return Container(
        width: width,
        height: height,
        color: color,
      );
    }
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
