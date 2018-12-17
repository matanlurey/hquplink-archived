import 'package:built_collection/built_collection.dart';
import 'package:flutter/material.dart';
import 'package:swlegion/swlegion.dart';

class DetailsUnitPage extends StatelessWidget {
  static const _lightSidePrimary = Color(0xFF833C34);
  static const _darkSidePrimary = Color(0xFF42556C);

  final Unit unit;

  const DetailsUnitPage(this.unit);

  @override
  build(context) {
    final theme = Theme.of(context);
    final factionColor = unit.faction == Faction.lightSide
        ? _lightSidePrimary
        : _darkSidePrimary;
    return Scaffold(
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            pinned: true,
            actions: [
              IconButton(
                icon: Icon(
                  Icons.add_box,
                  color: theme.primaryColorLight,
                ),
                onPressed: () {
                  // TODO: Do something.
                },
              )
            ],
            expandedHeight: 128,
            backgroundColor: factionColor,
            flexibleSpace: FlexibleSpaceBar(
              title: Container(
                child: Text(
                  unit.name,
                  textScaleFactor: 0.8,
                ),
              ),
              background: Stack(
                children: [
                  Container(
                    child: Image.asset(
                      'assets/faction.${unit.faction.name}.png',
                      fit: BoxFit.scaleDown,
                      color: Color.lerp(
                        factionColor,
                        Colors.white,
                        0.25,
                      ),
                    ),
                    padding: const EdgeInsets.fromLTRB(0, 20, 0, 20),
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
              ),
            ),
          ),
          SliverList(
            delegate: SliverChildListDelegate([
              _DetailCategory(
                title: 'Statistics',
                children: [
                  _DetailUnitStats(unit),
                ],
              ),
              _DetailCategory(
                title: 'Upgrade Slots',
                children: [
                  _DetailUnitSlots(unit.upgrades),
                ],
              ),
              // TODO: Fill in.
              const _DetailCategory(
                title: 'Weapons',
                children: [],
              ),
            ]),
          ),
        ],
      ),
    );
  }
}

class _DetailCategory extends StatelessWidget {
  final List<Widget> children;
  final String title;

  const _DetailCategory({
    @required this.children,
    @required this.title,
  });

  @override
  build(context) {
    final theme = Theme.of(context);
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 16),
      decoration: BoxDecoration(
        border: Border(
          bottom: BorderSide(color: theme.dividerColor),
        ),
      ),
      child: DefaultTextStyle(
        style: theme.textTheme.subhead,
        child: SafeArea(
          top: false,
          bottom: false,
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Column(
                  children: [
                    Text(
                      title,
                      style: theme.textTheme.headline,
                    )
                  ]..addAll(children),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _DetailUnitStats extends StatelessWidget {
  static String _capitalize(String input) {
    return input[0].toUpperCase() + input.substring(1);
  }

  final Unit unit;

  const _DetailUnitStats(
    this.unit,
  );

  @override
  build(_) {
    final children = [
      _DetailUnitPair(
        name: 'Type',
        value: _capitalize(unit.type.name),
      ),
      _DetailUnitPair(
        name: 'Rank',
        value: _capitalize(unit.rank.name),
      ),
      _DetailUnitPair(
        name: 'Points',
        value: '${unit.points}',
      ),
      _DetailUnitPair(
        name: 'Miniatures',
        value: '${unit.miniatures}',
      ),
      _DetailUnitPair(
        name: 'Wounds',
        value: '${unit.wounds}',
      ),
    ];
    final isVehicle = const [
      UnitType.repulsorVehicle,
      UnitType.vehicle,
    ].contains(unit.type);
    if (isVehicle) {
      children.add(_DetailUnitPair(
        name: 'Resilience',
        value: '${unit.resilience ?? '-'}',
      ));
    } else {
      children.add(_DetailUnitPair(
        name: 'Courage',
        value: '${unit.courage ?? '-'}',
      ));
    }
    children.addAll([
      _DetailUnitPair(
        name: 'Attack Surge',
        value: unit.attackSurge != null
            ? _capitalize(unit.attackSurge.name)
            : 'None',
      ),
      _DetailUnitPair(
        name: 'Defense Surge',
        value: unit.hasDefenseSurge ? 'Yes' : 'No',
      ),
      _DetailUnitPair(
        name: 'Speed',
        value: '${unit.speed}',
      ),
    ]);
    return Column(
      children: children,
    );
  }
}

class _DetailUnitSlots extends StatelessWidget {
  static String _capitalize(String input) {
    return input[0].toUpperCase() + input.substring(1);
  }

  final BuiltMap<UpgradeSlot, int> upgrades;

  const _DetailUnitSlots(
    this.upgrades,
  );

  @override
  build(context) {
    return Column(
      children: upgrades.entries.map((slot) {
        return _DetailUnitPair(
          name: _capitalize(slot.key.name),
          value: '${slot.value}',
        );
      }).toList(),
    );
  }
}

class _DetailUnitPair extends StatelessWidget {
  final String name;
  final String value;

  const _DetailUnitPair({
    @required this.name,
    @required this.value,
  });

  @override
  build(context) {
    final theme = Theme.of(context);
    return Container(
      child: Column(
        children: [
          Row(
            children: [
              Text(name, style: theme.textTheme.body1),
            ],
          ),
          Row(
            children: [
              Text(value, style: theme.textTheme.body2),
            ],
          ),
        ],
        mainAxisAlignment: MainAxisAlignment.start,
      ),
      padding: const EdgeInsets.symmetric(
        horizontal: 16,
        vertical: 8,
      ),
    );
  }
}
