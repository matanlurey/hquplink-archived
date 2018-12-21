import 'package:flutter/material.dart';
import 'package:meta/meta.dart';
import 'package:swlegion/swlegion.dart';

@Immutable()
class RankIcon extends StatelessWidget {
  static const _avatars = {
    Rank.commander: CircleAvatar(
      child: Text('CM'),
    ),
    Rank.operative: CircleAvatar(
      child: Text('OP'),
    ),
    Rank.corps: CircleAvatar(
      child: Text('CO'),
    ),
    Rank.specialForces: CircleAvatar(
      child: Text('SF'),
    ),
    Rank.support: CircleAvatar(
      child: Text('SP'),
    ),
    Rank.heavy: CircleAvatar(
      child: Text('HV'),
    ),
  };

  final Rank rank;

  RankIcon({this.rank}) : super(key: ValueKey(rank));

  @override
  build(_) => _avatars[rank];
}
