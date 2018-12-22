import 'package:flutter/material.dart';

class MaxPointsSlider extends StatelessWidget {
  final int maxPoints;
  final void Function(int) onChanged;

  const MaxPointsSlider({
    int maxPoints,
    @required this.onChanged,
  }) : maxPoints = maxPoints ?? 0;

  @override
  build(_) {
    return Column(
      children: [
        Text('Maximum Points: ${maxPoints == 0 ? '∞' : maxPoints}'),
        Slider(
          activeColor: Colors.blueAccent,
          value: maxPoints.toDouble(),
          divisions: 1600 ~/ 50,
          max: 1600,
          onChanged: (v) => onChanged(v == 0 ? null : v.toInt()),
        ),
      ],
    );
  }
}
