import 'package:flutter/material.dart';
import 'package:swlegion/swlegion.dart';

class DefenseDiceIcon extends StatelessWidget {
  final DefenseDice dice;

  DefenseDiceIcon(this.dice) : super(key: ValueKey(dice));

  @override
  build(_) {
    return Container(
      decoration: BoxDecoration(
        color: dice == DefenseDice.white ? Colors.white : Colors.red,
        border: Border.all(
          color: dice == DefenseDice.white ? Colors.red : Colors.white,
        ),
      ),
    );
  }
}
