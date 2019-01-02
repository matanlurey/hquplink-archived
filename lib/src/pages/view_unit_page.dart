import 'package:flutter/material.dart';
import 'package:hquplink/models.dart';
import 'package:hquplink/pages.dart';
import 'package:hquplink/patterns.dart';
import 'package:hquplink/services.dart';
import 'package:hquplink/widgets.dart';

/// Renders, and optionally, provides edits for a specific [ArmyUnit].
class ViewUnitPage extends StatefulWidget {
  /// Unit to be rendered.
  final ArmyUnit unit;

  /// Invoked when [unit] is updated. A value of `null` signifies deletion.
  final void Function(ArmyUnit) onUpdate;

  const ViewUnitPage({
    @required this.unit,
    @required this.onUpdate,
  }) : assert(unit != null);

  @override
  createState() => _ViewUnitState();
}

class _ViewUnitState extends Mutex<ArmyUnit, ViewUnitPage> {
  @override
  initMutex() => widget.unit;

  @override
  onUpdate() => widget.onUpdate(value);

  @override
  build(context) {
    final catalog = getCatalog(context);
    final details = catalog.toUnit(value.unit);
    final isVehicle = const [
      UnitType.groundVehicle,
      UnitType.repulsorVehicle,
    ].contains(details.type);
    return Scaffold(
      floatingActionButton: Builder(
        builder: (context) {
          return FloatingActionButton(
            child: const Icon(Icons.add),
            backgroundColor: Color.lerp(
              factionColor(details.faction),
              Colors.white,
              0.25,
            ),
            foregroundColor: Colors.white,
            onPressed: () => _addUpgrade(context),
          );
        },
      ),
      body: CustomScrollView(
        slivers: [
          FactionSliverHeader<_ViewUnitAction>(
            faction: details.faction,
            title: details.name,
            onMenuPressed: (option) async {
              switch (option) {
                case _ViewUnitAction.deleteUnit:
                  final details = getCatalog(context).toUnit(value.unit);
                  if (!await showConfirmDialog(
                    context: context,
                    discardText: 'Delete',
                    title: 'Delete ${details.name}?',
                  )) {
                    break;
                  }
                  widget.onUpdate(null);
                  return Navigator.pop(context);
              }
            },
            menu: const [
              PopupMenuItem(
                child: ListTile(
                  leading: const Icon(Icons.delete),
                  title: const Text('Delete Unit'),
                ),
                value: _ViewUnitAction.deleteUnit,
              ),
            ],
            bottom: _ViewUnitHeader(
              unit: value,
            ),
          ),
          SliverList(
            delegate: SliverChildListDelegate([
              Padding(
                padding: const EdgeInsets.all(8),
                child: Column(
                  children: [
                    Card(
                      child: _ViewUnitCard(
                        title: const Text('Details'),
                        subtitle: Row(
                          children: [
                            details.subTitle != null
                                ? Text('${details.subTitle}, ')
                                : const Text(''),
                            Text(toTitleCase(details.type.name)),
                          ],
                        ),
                        trailing: UnitAvatar(details),
                        body: _SimpleGrid(
                          data: {
                            'Points': Text('${details.points}'),
                            'Miniatures': Text('${details.miniatures}'),
                            'Wounds': Text('${details.wounds}'),
                            isVehicle ? 'Resilence' : 'Courage': Text(
                              '${(isVehicle ? details.resilience : details.courage) ?? '-'}',
                            ),
                            'Speed': Text('${details.speed}'),
                            'Defense': _buildDefenseValue(details),
                            'Attack': _buildAttackValue(details),
                          },
                          oddColor: factionColor(details.faction),
                        ),
                      ),
                    ),
                    Card(
                      child: _ViewUnitCard(
                        title: const Text('Keywords'),
                        body: _ViewUnitKeywords(unit: value),
                      ),
                    ),
                    Card(
                      child: _ViewUnitCard(
                        title: const Text('Upgrades'),
                        body: Builder(
                          builder: (context) {
                            return _ViewUnitUpgrades(
                              unit: value,
                              onDelete: (upgrade) {
                                return _deleteUpgrade(context, upgrade);
                              },
                            );
                          },
                        ),
                      ),
                    ),
                    Card(
                      child: _ViewUnitCard(
                        title: const Text('Weapons'),
                        body: _ViewUnitWeapons(
                          unit: value,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                padding: const EdgeInsets.only(bottom: 80),
              ),
            ]),
          ),
        ],
      ),
    );
  }

  void _addUpgrade(BuildContext context) async {
    final upgrade = await showDialog<Upgrade>(
      context: context,
      builder: (_) => _AddUpgradeDialog(unit: value),
    );
    if (upgrade != null) {
      setValue(
        value.rebuild((b) => b.upgrades.add(upgrade.toRef())),
      );
    }
  }

  void _deleteUpgrade(BuildContext context, Upgrade upgrade) {
    setValue(
      value.rebuild((b) => b.upgrades.remove(upgrade.toRef())),
      notifyRevert: context,
      describeRevert: (_) => 'Removed ${upgrade.name}',
    );
  }

  Widget _buildAttackValue(Unit details) {
    if (details.attackSurge == null) {
      return const Text('-');
    }
    final isCrit = details.attackSurge == AttackSurge.critical;
    return AttackSideIcon(
      side: isCrit ? AttackDiceSide.criticalHit : AttackDiceSide.hit,
      height: 12,
      color: Colors.white,
    );
  }
}

Widget _buildDefenseValue(Unit details) {
  final children = <Widget>[
    SizedBox(
      width: 12,
      height: 12,
      child: DefenseDiceIcon(dice: details.defense),
    ),
  ];
  if (details.hasDefenseSurge) {
    children.add(
      const Padding(
        padding: const EdgeInsets.only(left: 8),
        child: const DefenseSideIcon(
          side: DefenseDiceSide.surge,
          height: 16,
          color: Colors.white,
        ),
      ),
    );
  }
  return Row(children: children);
}

enum _ViewUnitAction {
  deleteUnit,
}

class _ViewUnitHeader extends StatelessWidget {
  final ArmyUnit unit;

  const _ViewUnitHeader({@required this.unit});

  @override
  build(context) {
    final catalog = getCatalog(context);
    final details = catalog.toUnit(unit.unit);
    final sumPoints = catalog.costOfUnit(unit.unit, upgrades: unit.upgrades);
    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: 12,
        vertical: 4,
      ),
      child: Row(
        children: [
          Row(
            children: [
              RankIcon(
                rank: details.rank,
                height: 12,
              ),
              Text(' ${toTitleCase(details.rank.name)}'),
            ],
          ),
          Row(
            children: [
              Text('$sumPoints Points'),
            ],
          ),
        ],
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
      ),
    );
  }
}

class _ViewUnitCard extends StatelessWidget {
  final Widget title;
  final Widget subtitle;
  final Widget leading;
  final Widget trailing;
  final Widget body;

  const _ViewUnitCard({
    @required this.title,
    @required this.body,
    this.subtitle,
    this.leading,
    this.trailing,
  });

  @override
  build(context) {
    final theme = Theme.of(context);
    return Column(
      children: [
        ListTile(
          title: DefaultTextStyle(
            style: theme.textTheme.title,
            child: title,
          ),
          leading: leading,
          subtitle: subtitle,
          trailing: trailing,
        ),
        Padding(
          child: body,
          padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
        ),
      ],
      crossAxisAlignment: CrossAxisAlignment.start,
    );
  }
}

class _SimpleGrid extends StatelessWidget {
  final Map<String, Widget> data;
  final Color oddColor;

  const _SimpleGrid({
    this.data,
    this.oddColor,
  });

  @override
  build(context) {
    final theme = Theme.of(context);
    final c = data.entries;
    final results = mapIndexed<Widget, MapEntry<String, Widget>>(c, (i, e) {
      return Container(
        padding: const EdgeInsets.all(8),
        color: i.isOdd ? null : oddColor ?? theme.primaryColor,
        child: Column(
          children: [
            Row(
              children: [
                Text(e.key),
                e.value,
              ],
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
            )
          ],
        ),
      );
    }).toList();
    return Column(
      children: results,
    );
  }
}

class _ViewUnitKeywords extends StatelessWidget {
  final ArmyUnit unit;

  const _ViewUnitKeywords({
    @required this.unit,
  });

  @override
  build(context) {
    final keywords = getCatalog(context).toUnit(unit.unit).keywords;
    return ListView(
      padding: const EdgeInsets.all(0),
      primary: false,
      shrinkWrap: true,
      children: ListTile.divideTiles(
        context: context,
        tiles: keywords.entries.map(
          (e) {
            return ListTile(
              title: Text(
                '${formatKeyword(e.key)} ${e.value}',
              ),
              contentPadding: const EdgeInsets.all(0),
              trailing: const Icon(Icons.chevron_right),
              onTap: () {
                ViewKeywordPage.navigateTo(context, e.key);
              },
            );
          },
        ),
      ).toList(),
    );
  }
}

class _ViewUnitUpgrades extends StatelessWidget {
  final ArmyUnit unit;
  final void Function(Upgrade) onDelete;

  const _ViewUnitUpgrades({
    @required this.unit,
    @required this.onDelete,
  });

  @override
  build(context) {
    final catalog = getCatalog(context);
    final upgrades = unit.upgrades.map(catalog.toUpgrade);
    return ListView(
      primary: false,
      shrinkWrap: true,
      padding: const EdgeInsets.all(0),
      children: ListTile.divideTiles(
        tiles: upgrades.map((upgrade) {
          return Dismissible(
            key: Key(upgrade.id),
            background: const DismissBackground(),
            direction: DismissDirection.startToEnd,
            onDismissed: (_) => onDelete(upgrade),
            child: ListTile(
              contentPadding: const EdgeInsets.all(0),
              trailing: UpgradeAvatar(upgrade),
              title: Text(
                upgrade.name,
                overflow: TextOverflow.ellipsis,
              ),
              subtitle: Text(
                '${toTitleCase(upgrade.type.name)}, ${upgrade.points} Points',
              ),
              // TODO: Add navigation for details of the upgrade.
              // And/or consider a points box here like previous page.
              // TODO: Add exhaustible icon.
            ),
          );
        }),
        context: context,
      ).toList(),
    );
  }
}

class _ViewUnitWeapons extends StatelessWidget {
  final ArmyUnit unit;

  const _ViewUnitWeapons({
    @required this.unit,
  });

  @override
  build(context) {
    return ListView(
      primary: false,
      shrinkWrap: true,
      padding: const EdgeInsets.all(0),
      children: ListTile.divideTiles(
        context: context,
        tiles: WeaponView.all(getCatalog(context), unit).map((weapon) {
          return WeaponListTile(weapon: weapon);
        }),
      ).toList(),
    );
  }
}

class _AddUpgradeDialog extends StatelessWidget {
  final ArmyUnit unit;

  const _AddUpgradeDialog({
    @required this.unit,
  }) : assert(unit != null);

  @override
  build(context) {
    final catalog = getCatalog(context);
    final current = unit.upgrades;
    final upgrades = catalog
        .upgradesForUnit(unit.unit)
        .where((u) => !current.contains(u.toRef()));

    return SimpleDialog(
      children: upgrades.map((upgrade) {
        return ListTile(
          leading: UpgradeAvatar(upgrade),
          title: Text(
            upgrade.name,
            overflow: TextOverflow.ellipsis,
          ),
          subtitle: Text(toTitleCase(upgrade.type.name)),
          trailing: Text('${upgrade.points}'),
          onTap: () => Navigator.pop(context, upgrade),
        );
      }).toList(),
      title: const Text('Add Upgrade'),
    );
  }
}
