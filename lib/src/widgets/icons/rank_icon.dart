import 'package:flutter/material.dart';
import 'package:meta/meta.dart';
import 'package:swlegion/swlegion.dart';

@Immutable()
class RankIcon extends StatelessWidget {
  final Rank rank;
  final double width;
  final double height;
  final Color color;
  final BoxFit fit;

  RankIcon({
    this.rank,
    this.width,
    this.height,
    this.color,
    this.fit,
  }) : super(key: ValueKey(rank));

  @override
  build(_) {
    return Image.asset(
      'assets/ranks/${rank.name}.png',
      width: width,
      height: height,
      color: color,
      fit: fit,
    );
  }
}
