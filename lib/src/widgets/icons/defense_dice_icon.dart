import 'package:flutter/material.dart';
import 'package:swlegion/swlegion.dart';

/// Creates an icon representing an defense dice for the provided [dice].
class DefenseDiceIcon extends StatelessWidget {
  final DefenseDice dice;

  DefenseDiceIcon({
    @required this.dice,
  }) : super(key: ValueKey(dice));

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
