import 'package:flutter/material.dart';
import 'package:hquplink/models.dart';
import 'package:hquplink/widgets.dart';

class FactionSliverHeader<T> extends StatelessWidget {
  final Faction faction;
  final Widget bottom;
  final String title;
  final void Function(T) onMenuPressed;
  final List<PopupMenuItem<T>> menu;

  const FactionSliverHeader({
    @required this.faction,
    @required this.title,
    @required this.onMenuPressed,
    this.bottom,
    this.menu = const [],
  });

  PreferredSize _buildBottom() {
    if (bottom == null) {
      return null;
    }
    return PreferredSize(
      preferredSize: const Size(0, 6),
      child: bottom,
    );
  }

  @override
  build(context) {
    return SliverAppBar(
      pinned: true,
      expandedHeight: 128,
      backgroundColor: factionColor(faction),
      flexibleSpace: FlexibleSpaceBar(
        background: _FactionDecoration(
          faction: faction,
        ),
      ),
      actions: [
        PopupMenuButton<T>(
          itemBuilder: (_) => menu,
          onSelected: onMenuPressed,
        ),
      ],
      title: Text(title),
      bottom: _buildBottom(),
    );
  }
}

class _FactionDecoration extends StatelessWidget {
  final Faction faction;

  _FactionDecoration({
    @required this.faction,
  }) : super(key: ValueKey(faction));

  @override
  build(context) {
    return Stack(
      children: [
        Padding(
          child: FactionIcon(
            faction,
            fit: BoxFit.scaleDown,
            color: Color.lerp(
              factionColor(faction),
              Colors.white,
              0.25,
            ),
          ),
          padding: const EdgeInsets.fromLTRB(0, 20, 0, 8),
        ),
        const DecoratedBox(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment(0.0, -1.0),
              end: Alignment(0.0, -0.4),
              colors: <Color>[Color(0x60000000), Color(0x00000000)],
            ),
          ),
        ),
      ],
      fit: StackFit.expand,
    );
  }
}
