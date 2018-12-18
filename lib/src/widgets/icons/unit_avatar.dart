import 'package:flutter/material.dart';
import 'package:swlegion/swlegion.dart';

/// Draws a [CircleAvatar] for the portrait of the provided [unit].
class UnitAvatar extends StatelessWidget {
  final Unit unit;

  const UnitAvatar(this.unit) : assert(unit != null);

  @override
  build(context) {
    return CircleAvatar(
      backgroundImage: AssetImage('assets/cards/${unit.id.toLowerCase()}.png'),
    );
  }
}
