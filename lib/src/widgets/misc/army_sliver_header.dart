import 'package:flutter/material.dart';
import 'package:hquplink/models.dart';
import 'package:hquplink/services.dart';
import 'package:hquplink/widgets.dart';

class ArmySliverHeader<T> extends StatelessWidget {
  final Army army;

  final void Function(T) onMenuPressed;
  final List<PopupMenuItem<T>> menu;

  const ArmySliverHeader({
    @required this.army,
    @required this.onMenuPressed,
    this.menu = const [],
  }) : assert(army != null);

  @override
  build(context) {
    return SliverAppBar(
      pinned: true,
      expandedHeight: 128,
      backgroundColor: factionColor(army.faction),
      flexibleSpace: FlexibleSpaceBar(
        background: _FactionDecoration(
          faction: army.faction,
        ),
      ),
      actions: [
        PopupMenuButton<T>(
          itemBuilder: (context) {
            return menu;
          },
          onSelected: onMenuPressed,
        ),
      ],
      title: Text(army.name),
      bottom: PreferredSize(
        preferredSize: const Size(0, 6),
        child: _ArmyHeader(
          army: army,
        ),
      ),
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

class _ArmyHeader extends StatelessWidget {
  final Army army;

  const _ArmyHeader({
    @required this.army,
  });

  @override
  build(context) {
    final catalog = getCatalog(context);
    final theme = Theme.of(context);
    final sumPoints = catalog.sumArmyPoints(army);
    final withinMax = army.maxPoints == null || sumPoints <= army.maxPoints;
    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: 8,
        vertical: 4,
      ),
      child: Row(
        children: [
          Row(
            children: [
              Text('${catalog.sumArmyPoints(army)}'),
              Text(
                ' / ${army.maxPoints ?? '∞'}',
                style: withinMax ? null : TextStyle(color: theme.errorColor),
              ),
              const Text(' Points'),
            ],
          ),
          Text('${army.units.length} Activations'),
        ],
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
      ),
    );
  }
}
