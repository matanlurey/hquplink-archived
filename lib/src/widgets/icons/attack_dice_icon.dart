import 'package:flutter/material.dart';
import 'package:swlegion/swlegion.dart';

/// Creates an icon representing an attack dice for the provided [dice].
class AttackDiceIcon extends StatelessWidget {
  static final _boxDecorations = {
    AttackDice.white: BoxDecoration(
      color: Colors.white,
      border: Border.all(
        color: Colors.black,
      ),
    ),
    AttackDice.black: BoxDecoration(
      color: Colors.black,
      border: Border.all(
        color: Colors.white,
      ),
    ),
    AttackDice.red: BoxDecoration(
      color: Colors.red,
      border: Border.all(
        color: Colors.white,
      ),
    ),
  };

  static const _degrees45 = 0.785398;

  /// Color of the attack dice to display.
  final AttackDice dice;

  AttackDiceIcon({
    @required this.dice,
  })  : assert(dice != null),
        super(key: ValueKey(dice));

  @override
  build(_) {
    return Transform.rotate(
      angle: _degrees45,
      child: Container(
        decoration: _boxDecorations[dice],
      ),
    );
  }
}
