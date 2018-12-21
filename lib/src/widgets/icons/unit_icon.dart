import 'package:flutter/material.dart';
import 'package:swlegion/swlegion.dart';

class UnitAvatar extends StatelessWidget {
  final Unit unit;

  const UnitAvatar(this.unit);

  @override
  build(_) {
    return CircleAvatar(
      backgroundImage: AssetImage(
        'assets/cards/${unit.id.toLowerCase()}.png',
      ),
    );
  }
}

class UnitIcon extends StatelessWidget {
  final Unit unit;
  final double width;
  final double height;
  final BoxFit fit;

  const UnitIcon(
    this.unit, {
    this.width,
    this.height,
    this.fit,
  }) : assert(unit != null);

  @override
  build(_) {
    return Image.asset(
      'assets/cards/${unit.id.toLowerCase()}.png',
      width: width,
      height: height,
      fit: fit,
    );
  }
}
