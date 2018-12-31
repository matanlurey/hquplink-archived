import 'package:flutter/material.dart';
import 'package:swlegion/swlegion.dart';

/// Creates an icon representing a side of an defense dice.
class DefenseSideIcon extends StatelessWidget {
  /// Side to display.
  final DefenseDiceSide side;

  /// Width of the icon.
  final double width;

  /// Height of the icon.
  final double height;

  /// Color override of the icon.
  final Color color;

  /// Fit option for the icon.
  final BoxFit fit;

  const DefenseSideIcon({
    @required this.side,
    this.width,
    this.height,
    this.color,
    this.fit,
  }) : assert(side != null);

  @override
  build(_) {
    if (side == DefenseDiceSide.blank) {
      return Container(
        width: width,
        height: height,
        color: color,
      );
    }
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
