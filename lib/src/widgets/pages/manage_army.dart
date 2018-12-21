import 'package:built_collection/built_collection.dart';
import 'package:flutter/material.dart';
import 'package:hquplink/services.dart';
import 'package:hquplink/widgets.dart';
import 'package:swlegion/database.dart' as catalog;
import 'package:swlegion/swlegion.dart';

class ManageArmyPage extends StatefulWidget {
  /// Army being managed.
  final Army army;

  /// Delete [army].
  final void Function() onDelete;

  /// Saves [army] as a new instance.
  final void Function(Army) onSave;

  const ManageArmyPage({
    @required this.army,
    @required this.onDelete,
    @required this.onSave,
  });

  @override
  createState() => _ManageArmyPageState(army);
}

class _ManageArmyPageState extends State<ManageArmyPage> {
  static final _formKey = GlobalKey<_ManageArmyPageState>();
  static const _lightSideColor = Color(0xFF833C34);
  static const _darkSideColor = Color(0xFF42556C);

  /// Army being viewed.
  Army _viewArmy;

  /// Army being edited.
  ArmyBuilder _editArmy;
  TextEditingController _editArmyName;

  _ManageArmyPageState(this._viewArmy);

  /// Whether we are currently editing the army.
  bool get _editMode => _editArmy != null;

  /// Enables editing mode.
  void _enableEditing() {
    setState(() {
      _editArmy = _viewArmy.toBuilder();
      _editArmyName = TextEditingController(text: _editArmy.name);
    });
  }

  /// Disables editing mode.
  void _saveEditing() {
    setState(() {
      _editArmy.name = _editArmyName.value.text;
      _viewArmy = _editArmy.build();
      _editArmy = null;
    });
  }

  /// Discards and disables editing mode.
  void _discardEditing() {
    setState(() {
      _editArmy = null;
    });
  }

  Future<bool> _onWillPop() async {
    if (!_editMode || _editArmy.build() == _viewArmy) {
      return true;
    }
    return await showConfirmDialog(
          context: context,
          title: 'Discard changes?',
          discardText: 'Discard',
        ) ??
        false;
  }

  /// Returns [Widget] action buttons for the current mode.
  List<Widget> _buildActions() {
    if (_editMode) {
      return [
        IconButton(
          icon: const Icon(Icons.save),
          onPressed: () {
            _saveEditing();
            widget.onSave(_viewArmy);
          },
        ),
        IconButton(
          icon: const Icon(Icons.delete),
          onPressed: () {
            widget.onDelete();
            _discardEditing();
            Navigator.of(context).pop();
          },
        ),
      ];
    } else {
      return [
        IconButton(
          icon: const Icon(Icons.edit),
          onPressed: () {
            setState(_enableEditing);
          },
        ),
      ];
    }
  }

  /// Returns the [Widget] for the [AppBar.title].
  Widget _buildTitle() => Text(_viewArmy.name);

  /// Returns the [Widget] for the [AppBar.leading].
  Widget _buildLeading() {
    if (_editMode) {
      return IconButton(
        icon: const Icon(Icons.close),
        onPressed: () async {
          final result = await _onWillPop();
          if (result) {
            _discardEditing();
          }
        },
      );
    }
    return null;
  }

  Widget _buildFormContents() {
    final viewPoints = Column(
      children: [
        Text(
          '${_viewArmy.points} Points | ${_viewArmy.units.length} Activations',
        ),
        const Divider(),
      ],
    );
    if (_editMode) {
      return Column(
        children: [
          TextField(
            controller: _editArmyName,
            decoration: const InputDecoration(
              labelText: 'Army Name',
            ),
            maxLength: 64,
          ),
          viewPoints,
        ],
      );
    } else {
      return viewPoints;
    }
  }

  void _onAddPressed(BuildContext context, Rank rank) async {
    final unit = await showDialog<Unit>(
      context: context,
      builder: (_) {
        return _AddUnitDialog(rank: rank, faction: _viewArmy.faction);
      },
    );
    if (unit != null) {
      final catalog = getCatalog(context);
      final newUnit = catalog.createArmyUnit()..unit = unit.toBuilder();
      setState(() {
        _editArmy.units.add(newUnit.build());
      });
    }
  }

  @override
  build(context) {
    final factionColor = _viewArmy.faction == Faction.lightSide
        ? _lightSideColor
        : _darkSideColor;
    final displayUnits = _editMode ? _editArmy.units.build() : _viewArmy.units;
    return Scaffold(
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            pinned: true,
            expandedHeight: 128,
            backgroundColor: factionColor,
            flexibleSpace: FlexibleSpaceBar(
              title: _buildTitle(),
              background: _FactionDecoration(
                faction: _viewArmy.faction,
                color: factionColor,
              ),
            ),
            actions: _buildActions(),
            leading: _buildLeading(),
          ),
          SliverList(
            delegate: SliverChildListDelegate([
              Form(
                onWillPop: _onWillPop,
                key: _formKey,
                child: Padding(
                  padding: const EdgeInsets.all(8),
                  child: _buildFormContents(),
                ),
              ),
              _ListAllRanks(
                units: displayUnits.toList(),
                editMode: _editMode,
                onAddPressed: (rank) => _onAddPressed(context, rank),
                onUpdated: (index, unit) {
                  if (unit == null) {
                    setState(() {
                      _editArmy.units.removeAt(index);
                    });
                  } else {
                    setState(() {
                      _editArmy.units[index] = unit;
                    });
                  }
                },
              ),
            ]),
          ),
        ],
      ),
    );
  }
}

class _FactionDecoration extends StatelessWidget {
  final Faction faction;
  final Color color;

  _FactionDecoration({
    @required this.faction,
    @required this.color,
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
              color,
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
    );
  }
}

class _ListAllRanks extends StatelessWidget {
  final bool editMode;
  final List<ArmyUnit> units;
  final void Function(Rank) onAddPressed;
  final void Function(int, ArmyUnit) onUpdated;

  const _ListAllRanks({
    @required this.editMode,
    @required this.units,
    @required this.onAddPressed,
    @required this.onUpdated,
  });

  @override
  build(context) {
    if (!editMode && units.isEmpty) {
      return const Center(child: Text('Press edit to add units'));
    }
    return Column(
      children: const [
        Rank.commander,
        Rank.operative,
        Rank.corps,
        Rank.specialForces,
        Rank.support,
        Rank.heavy,
      ].map((rank) {
        final units = this.units.where((u) => u.unit.rank == rank).toList();
        final header = _ListUnitRank(
          rank: rank,
          editMode: editMode,
          units: units,
          onAddPressed: () {
            onAddPressed(rank);
          },
        );
        final cards = units.map(
          (unit) {
            return _ViewUnitCard(
              editMode: editMode,
              unit: unit,
              onUpdated: (newUnit) {
                var index = 0;
                for (var i = 0; i < this.units.length; i++) {
                  if (unit.id == this.units[i].id) {
                    index = i;
                    break;
                  }
                }
                onUpdated(index, newUnit);
              },
            );
          },
        );
        return Column(
          children: [header]..addAll(cards),
        );
      }).toList(),
    );
  }
}

class _ListUnitRank extends StatelessWidget {
  final bool editMode;
  final Rank rank;
  final List<ArmyUnit> units;
  final void Function() onAddPressed;

  const _ListUnitRank({
    @required this.editMode,
    @required this.rank,
    @required this.units,
    @required this.onAddPressed,
  }) : assert(rank != null);

  @override
  build(context) {
    final titleText = Text(toTitleCase(rank.name));
    final trailing = <Widget>[
      Text('${units.length} / ${rank.maximum}'),
    ];
    if (editMode) {
      trailing.add(IconButton(
        icon: const Icon(Icons.add),
        onPressed: onAddPressed,
      ));
    }
    return Column(
      children: [
        ListTile(
          leading: RankIcon(rank: rank),
          title: titleText,
          trailing: Row(
            children: trailing,
            mainAxisSize: MainAxisSize.min,
          ),
        ),
      ],
    );
  }
}

class _ViewUnitCard extends StatelessWidget {
  final bool editMode;
  final ArmyUnit unit;
  final void Function(ArmyUnit) onUpdated;

  const _ViewUnitCard({
    @required this.editMode,
    @required this.unit,
    @required this.onUpdated,
  }) : assert(unit != null);

  @override
  build(context) {
    final theme = Theme.of(context);
    final tileTitles = [
      Text(
        unit.unit.name,
        style: theme.textTheme.body1,
      )
    ];
    if (unit.unit.subTitle != null) {
      tileTitles.add(Text(
        unit.unit.subTitle,
        style: theme.textTheme.body2.copyWith(
          color: theme.unselectedWidgetColor,
        ),
      ));
    }
    final allWeapons = unit.unit.weapons.toSet();
    for (final upgrade in unit.upgrades) {
      if (upgrade.weapon != null) {
        allWeapons.add(upgrade.weapon);
      }
    }
    Widget content = ExpansionTile(
      key: Key(unit.id),
      title: Row(
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: tileTitles,
          ),
          Container(
            decoration: BoxDecoration(
              color: theme.accentColor,
              border: Border.all(
                color: theme.dividerColor,
              ),
            ),
            padding: const EdgeInsets.all(4),
            child: ConstrainedBox(
              child: Text(
                '${unit.points}',
                style: theme.primaryTextTheme.caption.copyWith(
                  color: theme.accentTextTheme.headline.color,
                ),
                textAlign: TextAlign.center,
              ),
              constraints: const BoxConstraints(minWidth: 20),
            ),
          ),
        ],
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
      ),
      leading: UnitAvatar(unit.unit),
      children: [
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            children: [
              Text('Statistics', style: theme.textTheme.subhead),
              const Divider(),
              Row(
                children: [
                  Flexible(
                    flex: 6,
                    child: _DisplayKeywords(keywords: unit.unit.keywords),
                  ),
                  Flexible(
                    flex: 4,
                    child: _DisplayStatistics(unit: unit.unit),
                  ),
                ],
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.start,
              ),
              Column(
                children: [
                  _DisplayUpgrades(
                    unit: unit,
                    editMode: editMode,
                    onAddUpgrade: (upgrade) {
                      final unit = this.unit.toBuilder()..upgrades.add(upgrade);
                      onUpdated(unit.build());
                    },
                    onRemoveUpgrade: (upgrade) {
                      final unit = this.unit.toBuilder()
                        ..upgrades.remove(upgrade);
                      onUpdated(unit.build());
                    },
                  ),
                ],
              ),
              Column(
                children: [
                  Text('Weapons', style: theme.textTheme.subhead),
                  const Divider(),
                  Column(
                    children: allWeapons.map((weapon) {
                      final range = weapon.maxRange == 0
                          ? 'Melee'
                          : '${weapon.minRange} -> ${weapon.maxRange ?? '∞'}';
                      final dice = <Widget>[];
                      weapon.dice.forEach((type, amount) {
                        for (var i = 0; i < amount; i++) {
                          dice.add(
                            Padding(
                              padding: const EdgeInsets.all(4),
                              child: SizedBox(
                                width: 8,
                                height: 8,
                                child: AttackDiceIcon(type),
                              ),
                            ),
                          );
                        }
                      });
                      final subtitle = weapon.keywords.entries.map((word) {
                        return '${formatKeyword(word.key)} ${word.value}';
                      }).join(', ');
                      return DefaultTextStyle(
                        style: theme.textTheme.body1.copyWith(fontSize: 12),
                        child: Column(
                          children: [
                            ListTile(
                              title: Text(
                                weapon.name,
                                style: theme.textTheme.body1
                                    .copyWith(fontSize: 12),
                              ),
                              leading: Text(range),
                              trailing: Row(
                                children: dice,
                                mainAxisSize: MainAxisSize.min,
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 14,
                              ),
                              child: subtitle.isNotEmpty
                                  ? Text(
                                      subtitle,
                                      style: theme.textTheme.caption,
                                    )
                                  : null,
                            ),
                          ].where((w) => w != null).toList(),
                          crossAxisAlignment: CrossAxisAlignment.start,
                        ),
                      );
                    }).toList(),
                  )
                ],
              ),
            ],
          ),
        ),
      ],
    );
    if (editMode) {
      content = Dismissible(
        key: Key(unit.id),
        onDismissed: (_) {
          onUpdated(null);
        },
        background: const _DismissBackground(),
        child: content,
      );
    }
    return Card(
      child: content,
    );
  }
}

class _DismissBackground extends StatelessWidget {
  const _DismissBackground();

  @override
  build(context) {
    final theme = Theme.of(context);
    return Container(
      color: theme.primaryColor,
      child: Row(
        children: const [
          Icon(Icons.delete),
        ],
      ),
      padding: const EdgeInsets.symmetric(horizontal: 8),
    );
  }
}

class _DisplayKeywords extends StatelessWidget {
  final BuiltMap<Keyword, String> keywords;

  const _DisplayKeywords({
    @required this.keywords,
  });

  @override
  build(context) {
    final theme = Theme.of(context);
    return DefaultTextStyle(
      style: theme.textTheme.caption,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 4),
        child: Column(
          children: keywords.keys.map((keyword) {
            return Padding(
              padding: const EdgeInsets.fromLTRB(8, 8, 0, 0),
              child: Row(
                children: [
                  Text(formatKeyword(keyword)),
                  Text(' ${keywords[keyword]}'),
                ],
              ),
            );
          }).toList(),
        ),
      ),
    );
  }
}

class _DisplayStatistics extends StatelessWidget {
  final Unit unit;

  const _DisplayStatistics({
    @required this.unit,
  });

  @override
  build(context) {
    final theme = Theme.of(context);
    final isVehicle = const [
      UnitType.groundVehicle,
      UnitType.repulsorVehicle,
    ].contains(unit.type);
    return Column(
      children: [
        Text(
          toTitleCase(unit.type.name).toUpperCase(),
          style: theme.textTheme.caption,
        ),
        Padding(
          padding: const EdgeInsets.all(0),
          child: DefaultTextStyle(
            style: theme.textTheme.caption,
            child: Column(
              children: [
                Row(
                  children: [
                    const Text('Wounds'),
                    Text('${unit.wounds}'),
                  ],
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                ),
                Row(
                  children: [
                    Text('${isVehicle ? 'Resilence' : 'Courage'}'),
                    Text('${unit.courage ?? unit.resilience ?? '-'}'),
                  ],
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                ),
                Row(
                  children: [
                    const Text('Defense'),
                    SizedBox(
                      child: DefenseDiceIcon(unit.defense),
                      height: 12,
                      width: 12,
                    ),
                  ],
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                ),
                Row(
                  children: [
                    const Text('Surges D'),
                    Text(toTitleCase(unit.hasDefenseSurge ? 'Yes' : 'No')),
                  ],
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                ),
                Row(
                  children: [
                    const Text('Surges A'),
                    Text(toTitleCase(unit.attackSurge?.name ?? 'no')),
                  ],
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                ),
                Row(
                  children: [
                    const Text('Speed'),
                    Text('${unit.speed}'),
                  ],
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                ),
              ],
              crossAxisAlignment: CrossAxisAlignment.end,
              mainAxisAlignment: MainAxisAlignment.spaceAround,
            ),
          ),
        ),
      ],
      mainAxisAlignment: MainAxisAlignment.start,
    );
  }
}

class _DisplayUpgrades extends StatelessWidget {
  final bool editMode;
  final ArmyUnit unit;
  final void Function(Upgrade) onAddUpgrade;
  final void Function(Upgrade) onRemoveUpgrade;

  const _DisplayUpgrades({
    @required this.editMode,
    @required this.unit,
    @required this.onAddUpgrade,
    @required this.onRemoveUpgrade,
  });

  @override
  build(context) {
    final theme = Theme.of(context);
    final slots = unit.unit.upgrades.keys;
    final children = <Widget>[];
    if (unit.upgrades.isNotEmpty) {
      children.addAll([
        Text('Upgrades', style: theme.textTheme.subhead),
        const Divider(),
      ]);
    }
    for (final slot in slots) {
      final title = toTitleCase(slot.name);
      final upgrades = unit.upgrades.where((u) => u.type == slot).toList();
      if (editMode) {
        final trailing = <Widget>[
          Text('${upgrades.length} / ${unit.unit.upgrades[slot]}'),
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: () async {
              final upgrade = await showDialog<Upgrade>(
                  context: context,
                  builder: (_) {
                    return _AddUpgradeDialog(
                      slot: slot,
                      unit: unit.unit,
                    );
                  });
              if (upgrade != null) {
                onAddUpgrade(upgrade);
              }
            },
          )
        ];
        children.add(ListTile(
          contentPadding: const EdgeInsets.symmetric(horizontal: 4),
          leading: CircleAvatar(
            child: Text(title.substring(0, 2).toUpperCase()),
          ),
          title: Text(title),
          trailing: Row(
            children: trailing,
            mainAxisSize: MainAxisSize.min,
          ),
        ));
      }
      for (final upgrade in upgrades) {
        children.add(ListTile(
          contentPadding: const EdgeInsets.symmetric(horizontal: 4),
          leading: UpgradeAvatar(upgrade),
          title: Text(upgrade.name),
          trailing: editMode
              ? IconButton(
                  icon: const Icon(Icons.close),
                  onPressed: () {
                    onRemoveUpgrade(upgrade);
                  },
                )
              : null,
        ));
      }
    }
    return Column(
      children: children,
    );
  }
}

class _AddUnitDialog extends StatelessWidget {
  final Faction faction;
  final Rank rank;

  _AddUnitDialog({
    @required this.faction,
    @required this.rank,
  }) : super(key: ValueKey(rank));

  Iterable<Unit> _unitsOfRankAndFaction() {
    return catalog.units.where((u) => u.faction == faction && u.rank == rank);
  }

  @override
  build(context) {
    return SimpleDialog(
      title: Text('Add ${toTitleCase(rank.name)}'),
      children: _unitsOfRankAndFaction().map((unit) {
        return ListTile(
          title: Text(unit.name, overflow: TextOverflow.ellipsis),
          subtitle: unit.subTitle != null
              ? Text(unit.subTitle, overflow: TextOverflow.ellipsis)
              : null,
          trailing: Text('${unit.points}'),
          leading: UnitAvatar(unit),
          onTap: () {
            Navigator.pop(context, unit);
          },
        );
      }).toList(),
    );
  }
}

class _AddUpgradeDialog extends StatelessWidget {
  final Unit unit;
  final UpgradeSlot slot;

  _AddUpgradeDialog({
    @required this.unit,
    @required this.slot,
  }) : super(key: ValueKey(slot));

  Iterable<Upgrade> _upgradesForUnitAndSlot() {
    return catalog.upgrades.where((u) {
      if (u.type != slot) {
        return false;
      }
      if (u.restrictedToFaction != null) {
        return u.restrictedToFaction == unit.faction;
      }
      if (u.restrictedToUnit.isNotEmpty) {
        return u.restrictedToUnit.contains(unit);
      }
      return true;
    });
  }

  @override
  build(context) {
    return SimpleDialog(
      title: Text('Add ${toTitleCase(slot.name)} Upgrade'),
      children: _upgradesForUnitAndSlot().map((upgrade) {
        return ListTile(
          title: Text(upgrade.name, overflow: TextOverflow.ellipsis),
          trailing: Text('${upgrade.points}'),
          leading: UpgradeAvatar(upgrade),
          onTap: () {
            Navigator.pop(context, upgrade);
          },
        );
      }).toList(),
    );
  }
}
