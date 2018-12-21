import 'package:flutter/material.dart';
import 'package:swlegion/swlegion.dart';

class AttackDiceIcon extends StatelessWidget {
  static const _degrees45 = 0.785398;

  final AttackDice dice;

  AttackDiceIcon(this.dice) : super(key: ValueKey(dice));

  @override
  build(_) {
    final border = dice == AttackDice.white ? Colors.black : Colors.white;
    final color = const {
      AttackDice.white: Colors.white,
      AttackDice.black: Colors.black,
      AttackDice.red: Colors.red,
    }[dice];
    return Transform.rotate(
      angle: _degrees45,
      child: Container(
        decoration: BoxDecoration(
          color: color,
          border: Border.all(
            color: border,
          ),
        ),
      ),
    );
  }
}
